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
        # Create user-managed service accounts.
        # Create a service account in a namespace of your own, or replace one that already exists.
        # A replacement is not a partial update: every write applies the defaults, so an account that was disabled and is then written again without `enabled` comes back enabled.
        # Creating an account whose name still has leftover service tokens is rejected.
        # Delete those tokens first.
        # NOTE: The `elastic` namespace is reserved for the built-in service accounts that ship with Elasticsearch.
        # The `manage_service_account` privilege does not authorize this API.
        #
        # @option arguments [String] :namespace The namespace, which is a top-level grouping of service accounts.
        #  It must start with a letter or digit and can contain only letters, digits, hyphens, and underscores, up to a maximum of 128 characters.
        #  It cannot be `elastic`, which is reserved for built-in service accounts. (*Required*)
        # @option arguments [String] :service The service name.
        #  It must start with a letter or digit and can contain only letters, digits, hyphens, and underscores, up to a maximum of 128 characters. (*Required*)
        # @option arguments [String] :refresh If `wait_for` (the default) then wait for a refresh to make this operation visible to search, if `true` then refresh the affected shards to make this operation visible to search, if `false` then do nothing with refreshes. Server default: wait_for.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-put-user-managed-service-account
        #
        def put_user_managed_service_account(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.put_user_managed_service_account' }

          defined_params = [:namespace, :service].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'namespace' missing" unless arguments[:namespace]
          raise ArgumentError, "Required argument 'service' missing" unless arguments[:service]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _namespace = arguments.delete(:namespace)

          _service = arguments.delete(:service)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_security/service/#{Utils.listify(_namespace)}/#{Utils.listify(_service)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
