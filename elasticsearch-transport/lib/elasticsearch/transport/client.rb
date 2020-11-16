# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'base64'

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

      # The default host and port to use if not otherwise specified.
      #
      # @since 7.0.0
      DEFAULT_HOST = 'localhost:9200'.freeze

      # The default port to use if connecting using a Cloud ID.
      #
      # @since 7.2.0
      DEFAULT_CLOUD_PORT = 9243

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
      # @option arguments Array<Number> :retry_on_status Retry when specific status codes are returned
      #
      # @option arguments [Boolean] :reload_on_failure Reload connections after failure (false by default)
      #
      # @option arguments [Integer] :request_timeout The request timeout to be passed to transport in options
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
      # @option arguments [true, false] :compression Whether to compress requests. Gzip compression will be used.
      #   The default is false. Responses will automatically be inflated if they are compressed.
      #   If a custom transport object is used, it must handle the request compression and response inflation.
      #
      # @option api_key [String, Hash] :api_key Use API Key Authentication, either the base64 encoding of `id` and `api_key`
      #                                         joined by a colon as a String, or a hash with the `id` and `api_key` values.
      # @option opaque_id_prefix [String] :opaque_id_prefix set a prefix for X-Opaque-Id when initializing the client. This
      # will be prepended to the id you set before each request if you're using X-Opaque-Id
      #
      # @yield [faraday] Access and configure the `Faraday::Connection` instance directly with a block
      #
      def initialize(arguments={}, &block)
        @options = arguments.each_with_object({}){ |(k,v), args| args[k.to_sym] = v }
        @arguments = @options
        @arguments[:logger] ||= @arguments[:log]   ? DEFAULT_LOGGER.call() : nil
        @arguments[:tracer] ||= @arguments[:trace] ? DEFAULT_TRACER.call() : nil
        @arguments[:reload_connections] ||= false
        @arguments[:retry_on_failure]   ||= false
        @arguments[:reload_on_failure]  ||= false
        @arguments[:randomize_hosts]    ||= false
        @arguments[:transport_options]  ||= {}
        @arguments[:http]               ||= {}
        @options[:http]                 ||= {}

        set_api_key if (@api_key = @arguments[:api_key])

        @seeds = extract_cloud_creds(@arguments)
        @seeds ||= __extract_hosts(@arguments[:hosts] ||
                                     @arguments[:host] ||
                                     @arguments[:url] ||
                                     @arguments[:urls] ||
                                     ENV['ELASTICSEARCH_URL'] ||
                                     DEFAULT_HOST)

        @send_get_body_as = @arguments[:send_get_body_as] || 'GET'
        @opaque_id_prefix = @arguments[:opaque_id_prefix] || nil

        if @arguments[:request_timeout]
          @arguments[:transport_options][:request] = { timeout: @arguments[:request_timeout] }
        end

        if @arguments[:transport]
          @transport = @arguments[:transport]
        else
          transport_class  = @arguments[:transport_class] || DEFAULT_TRANSPORT_CLASS
          if transport_class == Transport::HTTP::Faraday
            @transport = transport_class.new(hosts: @seeds, options: @arguments) do |faraday|
              faraday.adapter(@arguments[:adapter] || __auto_detect_adapter)
              block&.call faraday
            end
          else
            @transport = transport_class.new(hosts: @seeds, options: @arguments)
          end
        end
      end

      # Performs a request through delegation to {#transport}.
      #
      def perform_request(method, path, params = {}, body = nil, headers = nil)
        method = @send_get_body_as if 'GET' == method && body
        if (opaque_id = params.delete(:opaque_id))
          headers = {} if headers.nil?
          opaque_id = @opaque_id_prefix ? "#{@opaque_id_prefix}#{opaque_id}" : opaque_id
          headers.merge!('X-Opaque-Id' => opaque_id)
        end
        transport.perform_request(method, path, params, body, headers)
      end

      private

      def set_api_key
        @api_key = __encode(@api_key) if @api_key.is_a? Hash
        headers = @arguments[:transport_options]&.[](:headers) || {}
        headers.merge!('Authorization' => "ApiKey #{@api_key}")
        @arguments[:transport_options].merge!(
          headers: headers
        )
        @arguments.delete(:user)
        @arguments.delete(:password)
      end

      def extract_cloud_creds(arguments)
        return unless arguments[:cloud_id] && !arguments[:cloud_id].empty?

        name = arguments[:cloud_id].split(':')[0]
        cloud_url, elasticsearch_instance = Base64.decode64(arguments[:cloud_id].gsub("#{name}:", '')).split('$')

        if cloud_url.include?(':')
          url, port = cloud_url.split(':')
          host = "#{elasticsearch_instance}.#{url}"
        else
          host = "#{elasticsearch_instance}.#{cloud_url}"
          port = arguments[:port] || DEFAULT_CLOUD_PORT
        end
        [
          {
            scheme: 'https',
            user: arguments[:user],
            password: arguments[:password],
            host: host,
            port: port.to_i
          }
        ]
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
      def __extract_hosts(hosts_config)
        hosts = case hosts_config
        when String
          hosts_config.split(',').map { |h| h.strip! || h }
        when Array
          hosts_config
        when Hash, URI
          [ hosts_config ]
        else
          Array(hosts_config)
        end

        host_list = hosts.map { |host| __parse_host(host) }
        @options[:randomize_hosts] ? host_list.shuffle! : host_list
      end

      def __parse_host(host)
        host_parts = case host
        when String
          if host =~ /^[a-z]+\:\/\//
            # Construct a new `URI::Generic` directly from the array returned by URI::split.
            # This avoids `URI::HTTP` and `URI::HTTPS`, which supply default ports.
            uri = URI::Generic.new(*URI.split(host))

            { :scheme => uri.scheme,
              :user => uri.user,
              :password => uri.password,
              :host => uri.host,
              :path => uri.path,
              :port => uri.port }
          else
            host, port = host.split(':')
            { :host => host,
              :port => port }
          end
        when URI
          { :scheme => host.scheme,
            :user => host.user,
            :password => host.password,
            :host => host.host,
            :path => host.path,
            :port => host.port }
        when Hash
          host
        else
          raise ArgumentError, "Please pass host as a String, URI or Hash -- #{host.class} given."
        end

        if @api_key
          # Remove Basic Auth if using API KEY
          host_parts.delete(:user)
          host_parts.delete(:password)
        else
          @options[:http][:user] ||= host_parts[:user]
          @options[:http][:password] ||= host_parts[:password]
        end

        host_parts[:port] = host_parts[:port].to_i if host_parts[:port]
        host_parts[:path].chomp!('/') if host_parts[:path]
        host_parts
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

      # Encode credentials for the Authorization Header
      # Credentials is the base64 encoding of id and api_key joined by a colon
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-create-api-key.html
      def __encode(api_key)
        Base64.strict_encode64([api_key[:id], api_key[:api_key]].join(':'))
      end
    end
  end
end
