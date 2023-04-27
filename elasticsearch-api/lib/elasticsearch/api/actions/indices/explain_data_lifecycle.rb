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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Indices
      module Actions
        # Retrieves information about the index's current DLM lifecycle, such as any potential encountered error, time since creation etc.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :index The name of the index to explain
        # @option arguments [Boolean] :include_defaults indicates if the API should return the default values the system uses for the index's lifecycle
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.8/dlm-explain-lifecycle.html
        #
        def explain_data_lifecycle(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.__listify(_index)}/_lifecycle/explain"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
