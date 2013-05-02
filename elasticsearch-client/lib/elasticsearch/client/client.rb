module Elasticsearch
  module Client
    class Client
      DEFAULT_TRANSPORT_CLASS  = Transport::HTTP::Faraday
      DEFAULT_SERIALIZER_CLASS = Serializer::MultiJson

      DEFAULT_LOGGER = lambda do
        require 'logger'
        logger = Logger.new(STDERR)
        logger.progname = 'elasticsearch'
        logger.formatter = proc { |severity, datetime, progname, msg| "#{datetime}: #{msg}\n" }
        logger
      end

      DEFAULT_TRACER = lambda do
        require 'logger'
        logger = Logger.new(STDERR)
        logger.progname = 'elasticsearch.tracer'
        logger.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }
        logger
      end

      attr_accessor :transport

      def initialize(hosts=nil, options={})
        transport_class  = options[:transport_class] || DEFAULT_TRANSPORT_CLASS
        options[:serializer_class] ||= DEFAULT_SERIALIZER_CLASS
        options[:logger] ||= options[:log]   ? DEFAULT_LOGGER.call() : nil
        options[:tracer] ||= options[:trace] ? DEFAULT_TRACER.call() : nil
        options[:rebuild_connections] ||= false
        @transport = options[:transport] || transport_class.new(:hosts => __extract_hosts(hosts), :options => options)
      end

      def perform_request(method, path, params={}, body=nil)
        transport.perform_request method, path, params, body
      end

      def __extract_hosts(hosts=nil)
        hosts = hosts.nil? ? ['localhost'] : Array(hosts)
        hosts.map do |host|
          case host
          when String
            # TODO: Handle protocol?
            host, port = host.split(':')
            { :host => host, :port => port }
          when Hash
            host
          else
            raise ArgumentError, "Please pass host as a String or Hash, #{host.class} given."
          end
        end
      end
    end
  end
end
