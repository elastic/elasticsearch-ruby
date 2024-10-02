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
    module MachineLearning
      module Actions
        # Retrieves anomaly detection job results for one or more categories.
        #
        # @option arguments [String] :job_id The name of the job
        # @option arguments [Long] :category_id The identifier of the category definition of interest
        # @option arguments [Integer] :from skips a number of categories
        # @option arguments [Integer] :size specifies a max number of categories to get
        # @option arguments [String] :partition_field_value Specifies the partition to retrieve categories for. This is optional, and should never be used for jobs where per-partition categorization is disabled.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Category selection details if not provided in URI
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/ml-get-category.html
        #
        def get_categories(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_categories' }

          defined_params = %i[job_id category_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          _category_id = arguments.delete(:category_id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path = if _job_id && _category_id
                   "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/results/categories/#{Utils.__listify(_category_id)}"
                 else
                   "_ml/anomaly_detectors/#{Utils.__listify(_job_id)}/results/categories"
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
