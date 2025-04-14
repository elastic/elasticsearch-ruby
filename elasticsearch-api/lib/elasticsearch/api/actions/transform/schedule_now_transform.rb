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
    module Transform
      module Actions
        # Schedule a transform to start now.
        # Instantly run a transform to process data.
        # If you run this API, the transform will process the new data instantly,
        # without waiting for the configured frequency interval. After the API is called,
        # the transform will be processed again at +now + frequency+ unless the API
        # is called again in the meantime.
        #
        # @option arguments [String] :transform_id Identifier for the transform. (*Required*)
        # @option arguments [Time] :timeout Controls the time to wait for the scheduling to take place Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-transform-schedule-now-transform
        #
        def schedule_now_transform(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'transform.schedule_now_transform' }

          defined_params = [:transform_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_transform/#{Utils.listify(_transform_id)}/_schedule_now"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
