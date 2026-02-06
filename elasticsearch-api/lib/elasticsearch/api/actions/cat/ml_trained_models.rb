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
    module Cat
      module Actions
        # Get trained models.
        # Get configuration and usage information about inference trained models.
        # IMPORTANT: CAT APIs are only intended for human consumption using the Kibana
        # console or command line. They are not intended for use by applications. For
        # application consumption, use the get trained models statistics API.
        #
        # @option arguments [String] :model_id A unique identifier for the trained model.
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request: contains wildcard expressions and there are no models that match; contains the `_all` string or no identifiers and there are no matches; contains wildcard expressions and there are only partial matches.
        #  If `true`, the API returns an empty array when there are no matches and the subset of results when there are partial matches.
        #  If `false`, the API returns a 404 status code when there are no matches or only partial matches. Server default: true.
        # @option arguments [String, Array<String>] :h A comma-separated list of column names to display.
        # @option arguments [String, Array<String>] :s A comma-separated list of column names or aliases used to sort the response.
        # @option arguments [Integer] :from Skips the specified number of transforms. Server default: 0.
        # @option arguments [Integer] :size The maximum number of transforms to display. Server default: 100.
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  `text`, `json`, `cbor`, `yaml`, or `smile`. Server default: text.
        # @option arguments [Boolean] :help When set to `true` will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to `true` will enable verbose output.
        # @option arguments [String] :bytes Sets the units for columns that contain a byte-size value.
        #  Note that byte-size value units work in terms of powers of 1024. For instance `1kb` means 1024 bytes, not 1000 bytes.
        #  If omitted, byte-size values are rendered with a suffix such as `kb`, `mb`, or `gb`, chosen such that the numeric value of the column is as small as possible whilst still being at least `1.0`.
        #  If given, byte-size values are rendered as an integer with no suffix, representing the value of the column in the chosen unit.
        #  Values that are not an exact multiple of the chosen unit are rounded down.
        # @option arguments [String] :time Sets the units for columns that contain a time duration.
        #  If omitted, time duration values are rendered with a suffix such as `ms`, `s`, `m` or `h`, chosen such that the numeric value of the column is as small as possible whilst still being at least `1.0`.
        #  If given, time duration values are rendered as an integer with no suffix.
        #  Values that are not an exact multiple of the chosen unit are rounded down.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-cat-ml-trained-models
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
