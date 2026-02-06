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
        # Create or update a trained model alias.
        # A trained model alias is a logical name used to reference a single trained
        # model.
        # You can use aliases instead of trained model identifiers to make it easier to
        # reference your models. For example, you can use aliases in inference
        # aggregations and processors.
        # An alias must be unique and refer to only a single trained model. However,
        # you can have multiple aliases for each trained model.
        # If you use this API to update an alias such that it references a different
        # trained model ID and the model uses a different type of data frame analytics,
        # an error occurs. For example, this situation occurs if you have a trained
        # model for regression analysis and a trained model for classification
        # analysis; you cannot reassign an alias from one type of trained model to
        # another.
        # If you use this API to update an alias and there are very few input fields in
        # common between the old and new trained models for the model alias, the API
        # returns a warning.
        #
        # @option arguments [String] :model_alias The alias to create or update. This value cannot end in numbers. (*Required*)
        # @option arguments [String] :model_id The identifier for the trained model that the alias refers to. (*Required*)
        # @option arguments [Boolean] :reassign Specifies whether the alias gets reassigned to the specified trained
        #  model if it is already assigned to a different model. If the alias is
        #  already assigned and this parameter is false, the API returns an error.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-ml-put-trained-model-alias
        #
        def put_trained_model_alias(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.put_trained_model_alias' }

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

          method = Elasticsearch::API::HTTP_PUT
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
