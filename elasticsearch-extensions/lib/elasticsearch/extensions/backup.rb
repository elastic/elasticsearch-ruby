# encoding: utf-8

require 'pathname'
require 'fileutils'

require 'multi_json'
require 'oj'

require 'elasticsearch'
require 'patron'

module Backup
  module Database

    # Integration with the Backup gem [https://github.com/meskyanichi/backup/]
    #
    # This extension allows to backup Elasticsearch indices as flat JSON files on the disk.
    #
    # Use the Backup gem's DSL to configure the backup:
    #
    #     require 'elasticsearch/extensions/backup'
    #
    #     Model.new(:elasticsearch_backup, 'Elasticsearch') do
    #
    #       database Elasticsearch do |db|
    #         # db.url     = 'http://localhost:9200'
    #         # db.indices = 'articles,people'
    #         # db.size    = 500
    #         # db.scroll  = '10m'
    #       end
    #
    #       store_with Local do |local|
    #         local.path = '/usr/local/var/backups'
    #         local.keep = 3
    #       end
    #
    #       compress_with Gzip
    #     end
    #
    # Perform the backup with the Backup gem's command line utility:
    #
    #     $ backup perform -t elasticsearch_backup
    #
    #
    # A simple recover script could look like this:
    #
    #     PATH = '/path/to/backup/'
    #
    #     require 'elasticsearch'
    #     client  = Elasticsearch::Client.new log: true
    #     payload = []
    #
    #     Dir[ File.join( PATH, '**', '*.json' ) ].each do |file|
    #       document = MultiJson.load(File.read(file))
    #       item = document.merge(data: document['_source'])
    #       document.delete('_source')
    #       document.delete('_score')
    #
    #       payload << { index: item }
    #
    #       if payload.size == 100
    #         client.bulk body: payload
    #         payload = []
    #       end
    #
    #       client.bulk body: payload
    #     end
    #
    # @see http://meskyanichi.github.io/backup/v4/
    #
    class Elasticsearch < Base
      class Error < ::Backup::Error; end

      attr_accessor :url,
                    :indices,
                    :size,
                    :scroll

      attr_accessor :mode

      def initialize(model, database_id = nil, &block)
        super

        @url     ||= 'http://localhost:9200'
        @indices ||= '_all'
        @size    ||= 100
        @scroll  ||= '10m'
        @mode    ||= 'single'

        instance_eval(&block) if block_given?
      end

      def perform!
        super

        case mode
          when 'single'
            __perform_single
          else
            raise Error, "Unsupported mode [#{mode}]"
        end

        log!(:finished)
      end

      def client
        @client ||= ::Elasticsearch::Client.new url: url, logger: logger
      end

      def path
        Pathname.new File.join(dump_path , dump_filename.downcase)
      end

      def logger
        logger = Backup::Logger.__send__(:logger)
        logger.instance_eval do
          def debug(*args);end
          # alias :debug :info
          alias :fatal :warn
        end
        logger
      end


      def __perform_single
        r = client.search index: indices, search_type: 'scan', scroll: scroll, size: size
        raise Error, "No scroll_id returned in response:\n#{r.inspect}" unless r['_scroll_id']

        while r = client.scroll(scroll_id: r['_scroll_id'], scroll: scroll) and not r['hits']['hits'].empty? do
          r['hits']['hits'].each do |hit|
            FileUtils.mkdir_p "#{path.join hit['_index'], hit['_type']}"
            File.open("#{path.join hit['_index'], hit['_type'], hit['_id']}.json", 'w') do |file|
              file.write MultiJson.dump(hit)
            end
          end
        end
      end
    end
  end
end

::Backup::Config::DSL::Elasticsearch = ::Backup::Database::Elasticsearch
