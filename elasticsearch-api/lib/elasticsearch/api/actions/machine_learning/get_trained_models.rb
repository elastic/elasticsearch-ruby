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
        # Get trained model configuration info.
        #
        # @option arguments [String, Array] :model_id The unique identifier of the trained model or a model alias.You can get information for multiple trained models in a single API
        #  request by using a comma-separated list of model IDs or a wildcard
        #  expression.
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request:
        #  - Contains wildcard expressions and there are no models that match.
        #  - Contains the _all string or no identifiers and there are no matches.
        #  - Contains wildcard expressions and there are only partial matches.
        #  If true, it returns an empty array when there are no matches and the
        #  subset of results when there are partial matches. Server default: true.
        # @option arguments [Boolean] :decompress_definition Specifies whether the included model definition should be returned as a
        #  JSON map (true) or in a custom compressed format (false). Server default: true.
        # @option arguments [Boolean] :exclude_generated Indicates if certain fields should be removed from the configuration on
        #  retrieval. This allows the configuration to be in an acceptable format to
        #  be retrieved and then added to another cluster.
        # @option arguments [Integer] :from Skips the specified number of models. Server default: 0.
        # @option arguments [String] :include A comma delimited string of optional fields to include in the response
        #  body.
        # @option arguments [Integer] :size Specifies the maximum number of models to obtain. Server default: 100.
        # @option arguments [String, Array<String>] :tags A comma delimited string of tags. A trained model can have many tags, or
        #  none. When supplied, only trained models that contain all the supplied
        #  tags are returned.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-ml-get-trained-models
        #
        def get_trained_models(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_trained_models' }

          defined_params = [:model_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _model_id = arguments.delete(:model_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _model_id
                     "_ml/trained_models/#{Utils.listify(_model_id)}"
                   else
                     '_ml/trained_models'
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
