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
# Auto generated from commit 3e97c19ea994ba17fbdaa94e813b27c345f9bbbd
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Connector
      module Actions
        # Delete a connector.
        # Removes a connector and associated sync jobs.
        # This is a destructive action that is not recoverable.
        # NOTE: This action doesn’t delete any API keys, ingest pipelines, or data indices associated with the connector.
        # These need to be removed manually.
        # This functionality is in Beta and is subject to change. The design and
        # code is less mature than official GA features and is being provided
        # as-is with no warranties. Beta features are not subject to the support
        # SLA of official GA features.
        #
        # @option arguments [String] :connector_id The unique identifier of the connector to be deleted (*Required*)
        # @option arguments [Boolean] :delete_sync_jobs A flag indicating if associated sync jobs should be also removed. Defaults to false.
        # @option arguments [Boolean] :hard A flag indicating if the connector should be hard deleted.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-connector-delete
        #
        def delete(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'connector.delete' }

          defined_params = [:connector_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'connector_id' missing" unless arguments[:connector_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _connector_id = arguments.delete(:connector_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_connector/#{Utils.listify(_connector_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
