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
        # Update a transform.
        # Updates certain properties of a transform.
        # All updated properties except +description+ do not take effect until after the transform starts the next checkpoint,
        # thus there is data consistency in each checkpoint. To use this API, you must have +read+ and +view_index_metadata+
        # privileges for the source indices. You must also have +index+ and +read+ privileges for the destination index. When
        # Elasticsearch security features are enabled, the transform remembers which roles the user who updated it had at the
        # time of update and runs with those privileges.
        #
        # @option arguments [String] :transform_id Identifier for the transform. (*Required*)
        # @option arguments [Boolean] :defer_validation When true, deferrable validations are not run. This behavior may be
        #  desired if the source index does not exist until after the transform is
        #  created.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the
        #  timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-update-transform
        #
        def update_transform(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'transform.update_transform' }

          defined_params = [:transform_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_transform/#{Utils.listify(_transform_id)}/_update"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
