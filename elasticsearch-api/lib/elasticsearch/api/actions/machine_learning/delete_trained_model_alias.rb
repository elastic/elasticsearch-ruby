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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Delete a trained model alias.
        # This API deletes an existing model alias that refers to a trained model. If
        # the model alias is missing or refers to a model other than the one identified
        # by the `model_id`, this API returns an error.
        #
        # @option arguments [String] :model_alias The model alias to delete. (*Required*)
        # @option arguments [String] :model_id The trained model ID to which the model alias refers. (*Required*)
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-ml-delete-trained-model-alias
        #
        def delete_trained_model_alias(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_trained_model_alias' }

          defined_params = [:model_id, :model_alias].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'model_id' missing" unless arguments[:model_id]
          raise ArgumentError, "Required argument 'model_alias' missing" unless arguments[:model_alias]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _model_alias = arguments.delete(:model_alias)

          _model_id = arguments.delete(:model_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_ml/trained_models/#{Utils.listify(_model_id)}/model_aliases/#{Utils.listify(_model_alias)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
