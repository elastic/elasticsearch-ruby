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
    module Connector
      module Actions
        # Update the connector draft filtering validation.
        # Update the draft filtering validation info for a connector.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :connector_id The unique identifier of the connector to be updated (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/update-connector-filtering-validation-api.html
        #
        def update_filtering_validation(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'connector.update_filtering_validation' }

          defined_params = [:connector_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'connector_id' missing" unless arguments[:connector_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _connector_id = arguments.delete(:connector_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_connector/#{Utils.listify(_connector_id)}/_filtering/_validation"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
