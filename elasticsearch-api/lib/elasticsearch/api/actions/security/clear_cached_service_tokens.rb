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
#
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Security
      module Actions
        # Clear service account token caches.
        # Evict a subset of all entries from the service account token caches.
        # Two separate caches exist for service account tokens: one cache for tokens backed by the `service_tokens` file, and another for tokens backed by the `.security` index.
        # This API clears matching entries from both caches.
        # The cache for service account tokens backed by the `.security` index is cleared automatically on state changes of the security index.
        # The cache for tokens backed by the `service_tokens` file is cleared automatically on file changes.
        #
        # @option arguments [String] :namespace The namespace, which is a top-level grouping of service accounts. (*Required*)
        # @option arguments [String] :service The name of the service, which must be unique within its namespace. (*Required*)
        # @option arguments [String, Array<String>] :name A comma-separated list of token names to evict from the service account token caches.
        #  Use a wildcard (`*`) to evict all tokens that belong to a service account.
        #  It does not support other wildcard patterns. (*Required*)
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-clear-cached-service-tokens
        #
        def clear_cached_service_tokens(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.clear_cached_service_tokens' }

          defined_params = [:namespace, :service, :name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'namespace' missing" unless arguments[:namespace]
          raise ArgumentError, "Required argument 'service' missing" unless arguments[:service]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _namespace = arguments.delete(:namespace)

          _service = arguments.delete(:service)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_POST
          path   = "_security/service/#{Utils.listify(_namespace)}/#{Utils.listify(_service)}/credential/token/#{Utils.listify(_name)}/_clear_cache"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
