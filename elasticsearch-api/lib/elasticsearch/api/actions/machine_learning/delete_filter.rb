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
    module MachineLearning
      module Actions
        # Delete a filter.
        # If an anomaly detection job references the filter, you cannot delete the
        # filter. You must update or delete the job before you can delete the filter.
        #
        # @option arguments [String] :filter_id A string that uniquely identifies a filter. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-delete-filter
        #
        def delete_filter(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_filter' }

          defined_params = [:filter_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'filter_id' missing" unless arguments[:filter_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _filter_id = arguments.delete(:filter_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_ml/filters/#{Utils.listify(_filter_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
