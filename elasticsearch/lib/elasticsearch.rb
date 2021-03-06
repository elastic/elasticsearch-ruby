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

require 'elasticsearch/version'
require 'elasticsearch/transport'
require 'elasticsearch/api'

module Elasticsearch
  # This is the stateful Elasticsearch::Client, using an instance of elasticsearch-transport.
  class Client
    include Elasticsearch::API
    # The default port to use if connecting using a Cloud ID.
    # Updated from 9243 to 443 in client version 7.10.1
    #
    # @since 7.2.0
    DEFAULT_CLOUD_PORT = 443

    # Create a client connected to an Elasticsearch cluster.
    #
    # @option arguments [String] :cloud_id - The Cloud ID to connect to Elastic Cloud
    # @option api_key [String, Hash] :api_key Use API Key Authentication, either the base64 encoding of `id` and `api_key`
    #                                         joined by a colon as a String, or a hash with the `id` and `api_key` values.
    # @option opaque_id_prefix [String] :opaque_id_prefix set a prefix for X-Opaque-Id when initializing the client.
    #                                                     This will be prepended to the id you set before each request
    #                                                     if you're using X-Opaque-Id
    def initialize(arguments = {}, &block)
      @opaque_id_prefix = arguments[:opaque_id_prefix] || nil
      api_key(arguments) if arguments[:api_key]
      if arguments[:cloud_id]
        arguments[:hosts] = setup_cloud_host(
          arguments[:cloud_id],
          arguments[:user],
          arguments[:password],
          arguments[:port]
        )
      end
      @transport = Elasticsearch::Transport::Client.new(arguments, &block)
    end

    def method_missing(name, *args, &block)
      if methods.include?(name)
        super
      elsif name == :perform_request
        # The signature for perform_request is:
        # method, path, params, body, headers
        if (opaque_id = args[2]&.delete(:opaque_id))
          headers = args[4] || {}
          opaque_id = @opaque_id_prefix ? "#{@opaque_id_prefix}#{opaque_id}" : opaque_id
          args[4] = headers.merge('X-Opaque-Id' => opaque_id)
        end
        @transport.send(name, *args, &block)
      else
        @transport.send(name, *args, &block)
      end
    end

    def respond_to_missing?(method_name, *args)
      @transport.respond_to?(method_name) || super
    end

    private

    def setup_cloud_host(cloud_id, user, password, port)
      name = cloud_id.split(':')[0]
      cloud_url, elasticsearch_instance = Base64.decode64(cloud_id.gsub("#{name}:", '')).split('$')

      if cloud_url.include?(':')
        url, port = cloud_url.split(':')
        host = "#{elasticsearch_instance}.#{url}"
      else
        host = "#{elasticsearch_instance}.#{cloud_url}"
        port ||= DEFAULT_CLOUD_PORT
      end
      [{ scheme: 'https', user: user, password: password, host: host, port: port.to_i }]
    end

    def api_key(arguments)
      api_key = if arguments[:api_key].is_a? Hash
                  encode(arguments[:api_key])
                else
                  arguments[:api_key]
                end
      arguments.delete(:user)
      arguments.delete(:password)
      authorization = { 'Authorization' => "ApiKey #{api_key}" }
      if (headers = arguments.dig(:transport_options, :headers))
        headers.merge!(authorization)
      else
        arguments[:transport_options] = {
          headers: authorization
        }
      end
    end

    # Encode credentials for the Authorization Header
    # Credentials is the base64 encoding of id and api_key joined by a colon
    # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/security-api-create-api-key.html
    def encode(api_key)
      Base64.strict_encode64([api_key[:id], api_key[:api_key]].join(':'))
    end
  end
end

# Helper for the meta-header value for Cloud
module Elastic
  # If the version is X.X.X.pre/alpha/beta, use X.X.Xp for the meta-header:
  def self.client_meta_version
    regexp = /^([0-9]+\.[0-9]+\.[0-9]+)\.?([a-z0-9.-]+)?$/
    match = Elasticsearch::VERSION.match(regexp)
    return "#{match[1]}p" if match[2]

    Elasticsearch::VERSION
  end

  # Constant for elasticsearch-transport meta-header
  ELASTICSEARCH_SERVICE_VERSION = [:es, client_meta_version].freeze
end
