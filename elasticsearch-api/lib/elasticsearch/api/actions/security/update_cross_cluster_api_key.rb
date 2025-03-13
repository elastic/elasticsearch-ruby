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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Security
      module Actions
        # Update a cross-cluster API key.
        # Update the attributes of an existing cross-cluster API key, which is used for API key based remote cluster access.
        # To use this API, you must have at least the +manage_security+ cluster privilege.
        # Users can only update API keys that they created.
        # To update another user's API key, use the +run_as+ feature to submit a request on behalf of another user.
        # IMPORTANT: It's not possible to use an API key as the authentication credential for this API.
        # To update an API key, the owner user's credentials are required.
        # It's not possible to update expired API keys, or API keys that have been invalidated by the invalidate API key API.
        # This API supports updates to an API key's access scope, metadata, and expiration.
        # The owner user's information, such as the +username+ and +realm+, is also updated automatically on every call.
        # NOTE: This API cannot update REST API keys, which should be updated by either the update API key or bulk update API keys API.
        #
        # @option arguments [String] :id The ID of the cross-cluster API key to update. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-update-cross-cluster-api-key
        #
        def update_cross_cluster_api_key(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.update_cross_cluster_api_key' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_security/cross_cluster/api_key/#{Utils.listify(_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
