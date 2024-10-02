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
        # Deletes expired and unused machine learning data.
        #
        # @option arguments [String] :job_id The ID of the job(s) to perform expired data hygiene for
        # @option arguments [Number] :requests_per_second The desired requests per second for the deletion processes.
        # @option arguments [Time] :timeout How long can the underlying delete processes run until they are canceled
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body deleting expired data parameters
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/ml-delete-expired-data.html
        #
        def delete_expired_data(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_expired_data' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = if _job_id
                     "_ml/_delete_expired_data/#{Utils.__listify(_job_id)}"
                   else
                     '_ml/_delete_expired_data'
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
