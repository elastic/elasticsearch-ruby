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
# Auto generated from build hash 589cd632d091bc0a512c46d5d81ac1f961b60127
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Create a filter
        #
        # @option arguments [String] :filter_id The ID of the filter to create
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The filter details (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.19/ml-put-filter.html
        #
        def put_filter(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.put_filter' }

          defined_params = [:filter_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'filter_id' missing" unless arguments[:filter_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _filter_id = arguments.delete(:filter_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_ml/filters/#{Utils.__listify(_filter_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
