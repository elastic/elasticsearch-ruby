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
    module MachineLearning
      module Actions
        # Get filters.
        # You can get a single filter or all filters.
        #
        # @option arguments [String, Array] :filter_id A string that uniquely identifies a filter.
        # @option arguments [Integer] :from Skips the specified number of filters. Server default: 0.
        # @option arguments [Integer] :size Specifies the maximum number of filters to obtain. Server default: 100.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-filters
        #
        def get_filters(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_filters' }

          defined_params = [:filter_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _filter_id = arguments.delete(:filter_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _filter_id
                     "_ml/filters/#{Utils.listify(_filter_id)}"
                   else
                     '_ml/filters'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
