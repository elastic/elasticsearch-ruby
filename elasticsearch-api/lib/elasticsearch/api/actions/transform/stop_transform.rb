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
    module Transform
      module Actions
        # Stops one or more transforms.
        #
        # @option arguments [String] :transform_id The id of the transform to stop
        # @option arguments [Boolean] :force Whether to force stop a failed transform or not. Default to false
        # @option arguments [Boolean] :wait_for_completion Whether to wait for the transform to fully stop before returning or not. Default to false
        # @option arguments [Time] :timeout Controls the time to wait until the transform has stopped. Default to 30 seconds
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no transforms. (This includes `_all` string or when no transforms have been specified)
        # @option arguments [Boolean] :wait_for_checkpoint Whether to wait for the transform to reach a checkpoint before stopping. Default to false
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/stop-transform.html
        #
        def stop_transform(arguments = {})
          raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_transform/#{Utils.__listify(_transform_id)}/_stop"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
