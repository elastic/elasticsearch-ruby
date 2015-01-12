module Elasticsearch
  module Transport

    # Handles communication with an Elasticsearch cluster.
    #
    # See {file:README.md README} for usage and code examples.
    #
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

      # Returns the transport object.
      #
      # @see Elasticsearch::Transport::Transport::Base
      # @see Elasticsearch::Transport::Transport::HTTP::Faraday
      #
      attr_accessor :transport

      # Create a client connected to an Elasticsearch cluster.
      #
      # Specify the URL via arguments or set the `ELASTICSEARCH_URL` environment variable.
      #
      # @option arguments [String,Array] :hosts Single host passed as a String or Hash, or multiple hosts
      #                                         passed as an Array; `host` or `url` keys are also valid
      #
      # @option arguments [Boolean] :log   Use the default logger (disabled by default)
      #
      # @option arguments [Boolean] :trace Use the default tracer (disabled by default)
      #
      # @option arguments [Object] :logger An instance of a Logger-compatible object
      #
      # @option arguments [Object] :tracer An instance of a Logger-compatible object
      #
      # @option arguments [Number] :resurrect_after After how many seconds a dead connection should be tried again
      #
      # @option arguments [Boolean,Number] :reload_connections Reload connections after X requests (false by default)
      #
      # @option arguments [Boolean] :randomize_hosts   Shuffle connections on initialization and reload (false by default)
      #
      # @option arguments [Integer] :sniffer_timeout   Timeout for reloading connections in seconds (1 by default)
      #
      # @option arguments [Boolean,Number] :retry_on_failure   Retry X times when request fails before raising and
      #                                                        exception (false by default)
      #
      # @option arguments [Boolean] :reload_on_failure Reload connections after failure (false by default)
      #
      # @option arguments [Symbol] :adapter A specific adapter for Faraday (e.g. `:patron`)
      #
      # @option arguments [Hash] :transport_options Options to be passed to the `Faraday::Connection` constructor
      #
      # @option arguments [Constant] :transport_class  A specific transport class to use, will be initialized by
      #                                                the client and passed hosts and all arguments
      #
      # @option arguments [Object] :transport A specific transport instance
      #
      # @option arguments [Constant] :serializer_class A specific serializer class to use, will be initialized by
      #                                               the transport and passed the transport instance
      #
      # @option arguments [Constant] :selector An instance of selector strategy implemented with
      #                                        {Elasticsearch::Transport::Transport::Connections::Selector::Base}.
      #
      # @option arguments [String] :send_get_body_as Specify the HTTP method to use for GET requests with a body.
      #                                              (Default: GET)
      #
      def initialize(arguments={})
        hosts = arguments[:hosts] || \
                arguments[:host]  || \
                arguments[:url]   || \
                arguments[:urls]  || \
                ENV.fetch('ELASTICSEARCH_URL', 'localhost:9200')

        arguments[:logger] ||= arguments[:log]   ? DEFAULT_LOGGER.call() : nil
        arguments[:tracer] ||= arguments[:trace] ? DEFAULT_TRACER.call() : nil
        arguments[:reload_connections] ||= false
        arguments[:retry_on_failure]   ||= false
        arguments[:reload_on_failure]  ||= false
        arguments[:randomize_hosts]    ||= false
        arguments[:transport_options]  ||= {}

        @send_get_body_as = arguments[:send_get_body_as] || 'GET'

        transport_class  = arguments[:transport_class] || DEFAULT_TRANSPORT_CLASS

        @transport       = arguments[:transport] || begin
          if transport_class == Transport::HTTP::Faraday
            transport_class.new(:hosts => __extract_hosts(hosts, arguments), :options => arguments) do |faraday|
              faraday.adapter(arguments[:adapter] || __auto_detect_adapter)
            end
          else
            transport_class.new(:hosts => __extract_hosts(hosts, arguments), :options => arguments)
          end
        end
      end

      # Performs a request through delegation to {#transport}.
      #
      def perform_request(method, path, params={}, body=nil)
        method = @send_get_body_as if 'GET' == method && body

        transport.perform_request method, path, params, body
      end

      # Normalizes and returns hosts configuration.
      #
      # Arrayifies the `hosts_config` argument and extracts `host` and `port` info from strings.
      # Performs shuffling when the `randomize_hosts` option is set.
      #
      # TODO: Refactor, so it's available in Elasticsearch::Transport::Base as well
      #
      # @return [Array<Hash>]
      # @raise  [ArgumentError]
      #
      # @api private
      #
      def __extract_hosts(hosts_config, options={})
        if hosts_config.respond_to?(:to_hash)
          hosts = [ hosts_config ]
        else
          if hosts_config.is_a?(String) && hosts_config.include?(',')
            hosts = hosts_config.split(/\s*,\s*/)
          else
            hosts = Array(hosts_config)
          end

          hosts.map! do |host|
            case host
            when String
              if host =~ /^[a-z]+\:\/\//
                uri = URI.parse(host)
                { :scheme => uri.scheme, :user => uri.user, :password => uri.password, :host => uri.host, :path => uri.path, :port => uri.port.to_s }
              else
                host, port = host.split(':')
                { :host => host, :port => port }
              end
            when URI
              { :scheme => host.scheme, :user => host.user, :password => host.password, :host => host.host, :path => host.path, :port => host.port.to_s }
            when Hash
              host
            else
              raise ArgumentError, "Please pass host as a String, URI or Hash -- #{host.class} given."
            end
          end
        end

        hosts.shuffle! if options[:randomize_hosts]
        hosts
      end

      # Auto-detect the best adapter (HTTP "driver") available, based on libraries
      # loaded by the user, preferring those with persistent connections
      # ("keep-alive") by default
      #
      # @return [Symbol]
      #
      # @api private
      #
      def __auto_detect_adapter
        case
        when defined?(::Patron)
          :patron
        when defined?(::Typhoeus)
          :typhoeus
        when defined?(::HTTPClient)
          :httpclient
        when defined?(::Net::HTTP::Persistent)
          :net_http_persistent
        else
          ::Faraday.default_adapter
        end
      end
    end
  end
end
