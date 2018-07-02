# encoding: utf-8

require 'pathname'
require 'fileutils'

require 'multi_json'

begin
  require 'oj'
rescue LoadError
  warn('The "oj" gem could not be loaded. JSON parsing and serialization performance may not be optimal.')
end

begin
  require 'patron'
rescue LoadError
  warn('The "patron" gem could not be loaded. HTTP requests may not be performed optimally.')
end

require 'elasticsearch'

module Backup
  module Database

    # Integration with the Backup gem [http://backup.github.io/backup/v4/]
    #
    # This extension allows to backup Elasticsearch indices as flat JSON files on the disk.
    #
    # @example Use the Backup gem's DSL to configure the backup
    #
    #     require 'elasticsearch/extensions/backup'
    #
    #     Model.new(:elasticsearch_backup, 'Elasticsearch') do
    #
    #       database Elasticsearch do |db|
    #         db.url     = 'http://localhost:9200'
    #         db.indices = 'articles,people'
    #         db.size    = 500
    #         db.scroll  = '10m'
    #       end
    #
    #       store_with Local do |local|
    #         local.path = '/tmp/backups'
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
    # The Backup gem can store your backup files on S3, Dropbox and other
    # cloud providers, send notifications about the operation, and so on;
    # read more in the gem documentation.
    #
    # @example Use the integration as a standalone script (eg. in a Rake task)
    #
    #     require 'backup'
    #     require 'elasticsearch/extensions/backup'
    #
    #     Backup::Logger.configure do
    #       logfile.enabled   = true
    #       logfile.log_path  = '/tmp/backups/log'
    #     end; Backup::Logger.start!
    #
    #     backup  = Backup::Model.new(:elasticsearch, 'Backup Elasticsearch') do
    #       database Backup::Database::Elasticsearch do |db|
    #         db.indices = 'test'
    #       end
    #
    #       store_with Backup::Storage::Local do |local|
    #         local.path = '/tmp/backups'
    #       end
    #     end
    #
    #     backup.perform!
    #
    # @example A simple recover script for the backup created in the previous examples
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
    # @see http://backup.github.io/backup/v4/
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
