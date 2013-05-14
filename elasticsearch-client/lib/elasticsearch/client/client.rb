module Elasticsearch
  module Client
    class Client
      DEFAULT_TRANSPORT_CLASS  = Transport::HTTP::Faraday

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

      def initialize(arguments={})
        transport_class  = arguments[:transport_class] || DEFAULT_TRANSPORT_CLASS
        hosts            = arguments[:hosts] || arguments[:host] || arguments[:url]

        arguments[:logger] ||= arguments[:log]   ? DEFAULT_LOGGER.call() : nil
        arguments[:tracer] ||= arguments[:trace] ? DEFAULT_TRACER.call() : nil
        arguments[:reload_connections] ||= false
        arguments[:retry_on_failure]   ||= false
        arguments[:reload_on_failure]  ||= false
        arguments[:randomize_hosts]    ||= false

        @transport = arguments[:transport] || \
                     transport_class.new(:hosts => __extract_hosts(hosts, arguments), :options => arguments)
      end

      def perform_request(method, path, params={}, body=nil)
        transport.perform_request method, path, params, body
      end

      def __extract_hosts(hosts_config=nil, options={})
        hosts_config = hosts_config.nil? ? ['localhost'] : Array(hosts_config)

        hosts = hosts_config.map do |host|
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

        hosts.shuffle! if options[:randomize_hosts]
        hosts
      end
    end
  end
end
