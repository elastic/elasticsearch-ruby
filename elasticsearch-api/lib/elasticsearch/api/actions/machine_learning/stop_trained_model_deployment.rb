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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Stop a trained model deployment.
        #
        # @option arguments [String] :model_id The unique identifier of the trained model. (*Required*)
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request: contains wildcard expressions and there are no deployments that match;
        #  contains the  +_all+ string or no identifiers and there are no matches; or contains wildcard expressions and
        #  there are only partial matches. By default, it returns an empty array when there are no matches and the subset of results when there are partial matches.
        #  If +false+, the request returns a 404 status code when there are no matches or only partial matches. Server default: true.
        # @option arguments [Boolean] :force Forcefully stops the deployment, even if it is used by ingest pipelines. You can't use these pipelines until you
        #  restart the model deployment.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-stop-trained-model-deployment
        #
        def stop_trained_model_deployment(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.stop_trained_model_deployment' }

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
          path   = "_ml/trained_models/#{Utils.listify(_model_id)}/deployment/_stop"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
