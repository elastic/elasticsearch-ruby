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

          # TODO: Description
          #
          # @option arguments [String] :datafeed_id The ID of the datafeed to delete (*Required*)
          # @option arguments [Boolean] :force True if the datafeed should be forcefully deleted
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-delete-datafeed.html
          #
          def delete_datafeed(arguments={})
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]
            valid_params = [
              :force ]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/ml/datafeeds/#{arguments[:datafeed_id]}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
