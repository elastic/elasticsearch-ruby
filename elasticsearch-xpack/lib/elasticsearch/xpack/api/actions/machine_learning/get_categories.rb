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

          # Retrieve job results for one or more categories
          #
          # @option arguments [String] :job_id The name of the job (*Required*)
          # @option arguments [Long] :category_id The identifier of the category definition of interest
          # @option arguments [Hash] :body Category selection details if not provided in URI
          # @option arguments [Int] :from skips a number of categories
          # @option arguments [Int] :size specifies a max number of categories to get
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-category.html
          #
          def get_categories(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            valid_params = [
              :from,
              :size ]
            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify "_xpack/ml/anomaly_detectors", arguments[:job_id], "results/categories", arguments[:category_id]
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
