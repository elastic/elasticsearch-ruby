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
        # Start a trained model deployment.
        #
        # @option arguments [String] :model_id The unique identifier of the trained model. (*Required*)
        # @option arguments [String] :cache_size A byte-size value for configuring the inference cache size. For example, 20mb.
        # @option arguments [String] :deployment_id The Id of the new deployment. Defaults to the model_id if not set.
        # @option arguments [Integer] :number_of_allocations The total number of allocations this model is assigned across machine learning nodes.
        # @option arguments [Integer] :threads_per_allocation The number of threads used by each model allocation during inference.
        # @option arguments [String] :priority The deployment priority.
        # @option arguments [Integer] :queue_capacity Controls how many inference requests are allowed in the queue at a time.
        # @option arguments [Time] :timeout Controls the amount of time to wait for the model to deploy.
        # @option arguments [String] :wait_for The allocation status for which to wait (options: starting, started, fully_allocated)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/start-trained-model-deployment.html
        #
        def start_trained_model_deployment(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.start_trained_model_deployment' }

          defined_params = [:model_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _model_id = arguments.delete(:model_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/trained_models/#{Utils.__listify(_model_id)}/deployment/_start"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
