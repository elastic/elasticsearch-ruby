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
  SECURITY_PRIVILEGES_VALIDATION_WARNING = 'The client is unable to verify that the server is Elasticsearch due to security privileges on the server side. Some functionality may not be compatible if the server is running an unsupported product.'.freeze
  NOT_ELASTICSEARCH_WARNING = 'The client noticed that the server is not Elasticsearch and we do not support this unknown product.'.freeze
  NOT_SUPPORTED_ELASTICSEARCH_WARNING = 'The client noticed that the server is not a supported distribution of Elasticsearch.'.freeze
  YOU_KNOW_FOR_SEARCH = 'You Know, for Search'.freeze

  class Client
    include Elasticsearch::API
    attr_accessor :transport

    # See Elasticsearch::Transport::Client for initializer parameters
    def initialize(arguments = {}, &block)
      @verified = false
      @transport = Elasticsearch::Transport::Client.new(arguments, &block)
    end

    def method_missing(name, *args, &block)
      if name == :perform_request
        verify_elasticsearch unless @verified
        @transport.perform_request(*args, &block)
      else
        super
      end
    end

    private

    def verify_elasticsearch
      begin
        response = elasticsearch_validation_request
      rescue Elasticsearch::Transport::Transport::Errors::Unauthorized,
             Elasticsearch::Transport::Transport::Errors::Forbidden
        @verified = true
        warn(SECURITY_PRIVILEGES_VALIDATION_WARNING)
        return
      end

      body = if response.headers['content-type'] == 'application/yaml'
               require 'yaml'
               YAML.load(response.body)
             else
               response.body
             end
      version = body.dig('version', 'number')
      verify_with_version_or_header(body, version, response.headers)
    end

    def verify_with_version_or_header(body, version, headers)
      raise Elasticsearch::UnsupportedProductError if version.nil? || version < '6.0.0'

      if version == '7.x-SNAPSHOT' || Gem::Version.new(version) >= Gem::Version.new('7.14-SNAPSHOT')
        raise Elasticsearch::UnsupportedProductError unless headers['x-elastic-product'] == 'Elasticsearch'

        @verified = true
      elsif Gem::Version.new(version) > Gem::Version.new('6.0.0') &&
            Gem::Version.new(version) < Gem::Version.new('7.0.0')
        raise Elasticsearch::UnsupportedProductError unless
          body['tagline'] == YOU_KNOW_FOR_SEARCH

        @verified = true
      elsif Gem::Version.new(version) >= Gem::Version.new('7.0.0') &&
            Gem::Version.new(version) < Gem::Version.new('7.14-SNAPSHOT')
        raise Elasticsearch::UnsupportedProductError unless body['tagline'] == YOU_KNOW_FOR_SEARCH
        raise Elasticsearch::UnsupportedProductError.new(NOT_SUPPORTED_ELASTICSEARCH_WARNING) unless body.dig('version', 'build_flavor') == 'default'

        @verified = true
      end
    end

    def elasticsearch_validation_request
      @transport.perform_request('GET', '/')
    end
  end

  class UnsupportedProductError < StandardError
    def initialize(message = NOT_ELASTICSEARCH_WARNING)
      super(message)
    end
  end
end

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
