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
require 'elasticsearch/transport/meta_header'

module Elasticsearch
  module Transport
    # Handles communication with an Elasticsearch cluster.
    #
    # See {file:README.md README} for usage and code examples.
    #
    class Client
      DEFAULT_TRANSPORT_CLASS = Transport::HTTP::Faraday
      include MetaHeader

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

      # The default port to use if not otherwise specified.
      #
      # @since 7.2.0
      DEFAULT_PORT = 9200

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
      # @option enable_meta_header [Boolean] :enable_meta_header Enable sending the meta data header to Cloud.
      #                                                          (Default: true)
      #
      # @yield [faraday] Access and configure the `Faraday::Connection` instance directly with a block
      #
      def initialize(arguments = {}, &block)
        @options = arguments.transform_keys(&:to_sym)
        @arguments = @options
        @arguments[:logger] ||= @arguments[:log]   ? DEFAULT_LOGGER.call() : nil
        @arguments[:tracer] ||= @arguments[:trace] ? DEFAULT_TRACER.call() : nil
        @arguments[:reload_connections] ||= false
        @arguments[:retry_on_failure]   ||= false
        @arguments[:reload_on_failure]  ||= false
        @arguments[:randomize_hosts]    ||= false
        @arguments[:transport_options]  ||= {}
        @arguments[:http]               ||= {}
        @arguments[:enable_meta_header] = arguments.fetch(:enable_meta_header, true)
        @options[:http]                 ||= {}

        @hosts = __extract_hosts(@arguments[:hosts] ||
                                 @arguments[:host] ||
                                 @arguments[:url] ||
                                 @arguments[:urls] ||
                                 ENV['ELASTICSEARCH_URL'] ||
                                 DEFAULT_HOST)

        @send_get_body_as = @arguments[:send_get_body_as] || 'GET'

        if @arguments[:request_timeout]
          @arguments[:transport_options][:request] = { timeout: @arguments[:request_timeout] }
        end

        if @arguments[:transport]
          @transport = @arguments[:transport]
        else
          @transport_class = @arguments[:transport_class] || DEFAULT_TRANSPORT_CLASS
          @transport = if @transport_class == Transport::HTTP::Faraday
                         @arguments[:adapter] ||= __auto_detect_adapter
                         set_meta_header # from include MetaHeader
                         @transport_class.new(hosts: @hosts, options: @arguments) do |faraday|
                           faraday.adapter(@arguments[:adapter])
                           block&.call faraday
                         end
                       else
                         set_meta_header # from include MetaHeader
                         @transport_class.new(hosts: @hosts, options: @arguments)
                       end
        end
      end
      # Performs a request through delegation to {#transport}.
      #
      def perform_request(method, path, params = {}, body = nil, headers = nil)
        method = @send_get_body_as if 'GET' == method && body
        transport.perform_request(method, path, params, body, headers)
      end

      private

      def add_header(header)
        headers = @arguments[:transport_options]&.[](:headers) || {}
        headers.merge!(header)
        @arguments[:transport_options].merge!(
          headers: headers
        )
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
                  [hosts_config]
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

                         default_port = uri.scheme == 'https' ? 443 : DEFAULT_PORT

                         { :scheme => uri.scheme,
                           :user => uri.user,
                           :password => uri.password,
                           :host => uri.host,
                           :path => uri.path,
                           :port => uri.port || default_port }
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
    end
  end
end
