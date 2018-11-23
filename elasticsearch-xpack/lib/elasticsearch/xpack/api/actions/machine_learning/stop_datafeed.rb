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
      module MachineLearning
        module Actions

          # Stop a datafeed
          #
          # @option arguments [String] :datafeed_id The ID of the datafeed to stop (*Required*)
          # @option arguments [Boolean] :allow_no_datafeeds Whether to ignore if a wildcard expression matches no datafeeds. (This includes `_all` string or when no datafeeds have been specified)
          # @option arguments [Boolean] :force True if the datafeed should be forcefully stopped.
          # @option arguments [Time] :timeout Controls the time to wait until a datafeed has stopped. Default to 20 seconds
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-stop-datafeed.html
          #
          def stop_datafeed(arguments={})
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]
            valid_params = [
              :allow_no_datafeeds,
              :force,
              :timeout ]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/datafeeds/#{arguments[:datafeed_id]}/_stop"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
