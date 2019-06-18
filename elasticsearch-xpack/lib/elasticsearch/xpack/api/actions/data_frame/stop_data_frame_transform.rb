# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions

          # Start a data frame analytics job.
          #
          # @option arguments [String] :transform_id The id of the transform to stop.
          # @option arguments [String] :timeout Controls the time to wait until the transform has stopped.
          #   Default to 30 seconds.
          # @option arguments [String] :wait_for_completion Whether to wait for the transform to fully stop before
          #   returning or not. Default to false.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/stop-data-frame-transform.html
          #
          def stop_data_frame_transform(arguments={})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]
            arguments = arguments.clone
            transform_id = URI.escape(arguments.delete(:transform_id))

            valid_params = [
                :timeout,
                :wait_for_completion ]

            method = Elasticsearch::API::HTTP_POST
            path   = "_data_frame/transforms/#{transform_id}/_stop"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
