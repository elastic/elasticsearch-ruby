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

          # Retrieves usage information for data frame transforms.
          #
          # @option arguments [Integer] :transform_id The id or comma delimited list of id expressions of the
          #   transforms to get, '_all' or '*' implies get all transforms.
          # @option arguments [Integer] :from Skips a number of transform configs, defaults to 0
          # @option arguments [Integer] :type Specifies a max number of transform stats to get, defaults to 10
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/get-data-frame-transform-stats.html
          #
          def get_data_frame_transform_stats(arguments={})
            arguments = arguments.clone
            transform_id = URI.escape(arguments.delete(:transform_id))

            valid_params = [
                :from,
                :size]

            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify( '_data_frame/transforms', Elasticsearch::API::Utils.__listify(transform_id), '_stats' )
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
