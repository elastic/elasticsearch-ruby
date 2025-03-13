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
    module Cat
      module Actions
        # Get trained models.
        # Get configuration and usage information about inference trained models.
        # IMPORTANT: CAT APIs are only intended for human consumption using the Kibana
        # console or command line. They are not intended for use by applications. For
        # application consumption, use the get trained models statistics API.
        #
        # @option arguments [String] :model_id A unique identifier for the trained model.
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request: contains wildcard expressions and there are no models that match; contains the +_all+ string or no identifiers and there are no matches; contains wildcard expressions and there are only partial matches.
        #  If +true+, the API returns an empty array when there are no matches and the subset of results when there are partial matches.
        #  If +false+, the API returns a 404 status code when there are no matches or only partial matches. Server default: true.
        # @option arguments [String] :bytes The unit used to display byte values.
        # @option arguments [String, Array<String>] :h A comma-separated list of column names to display.
        # @option arguments [String, Array<String>] :s A comma-separated list of column names or aliases used to sort the response.
        # @option arguments [Integer] :from Skips the specified number of transforms.
        # @option arguments [Integer] :size The maximum number of transforms to display.
        # @option arguments [String] :time Unit used to display time values.
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  +text+, +json+, +cbor+, +yaml+, or +smile+. Server default: text.
        # @option arguments [Boolean] :help When set to +true+ will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to +true+ will enable verbose output.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-ml-trained-models
        #
        def ml_trained_models(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.ml_trained_models' }

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
                     "_cat/ml/trained_models/#{Utils.listify(_model_id)}"
                   else
                     '_cat/ml/trained_models'
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
