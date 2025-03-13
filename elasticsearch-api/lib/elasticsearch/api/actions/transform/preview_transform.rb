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
    module Transform
      module Actions
        # Preview a transform.
        # Generates a preview of the results that you will get when you create a transform with the same configuration.
        # It returns a maximum of 100 results. The calculations are based on all the current data in the source index. It also
        # generates a list of mappings and settings for the destination index. These values are determined based on the field
        # types of the source index and the transform aggregations.
        #
        # @option arguments [String] :transform_id Identifier for the transform to preview. If you specify this path parameter, you cannot provide transform
        #  configuration details in the request body.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the
        #  timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-preview-transform
        #
        def preview_transform(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'transform.preview_transform' }

          defined_params = [:transform_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _transform_id = arguments.delete(:transform_id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = if _transform_id
                     "_transform/#{Utils.listify(_transform_id)}/_preview"
                   else
                     '_transform/_preview'
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
