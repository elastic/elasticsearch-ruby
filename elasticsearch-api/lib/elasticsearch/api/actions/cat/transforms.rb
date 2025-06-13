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
        # Get transform information.
        # Get configuration and usage information about transforms.
        # CAT APIs are only intended for human consumption using the Kibana
        # console or command line. They are not intended for use by applications. For
        # application consumption, use the get transform statistics API.
        #
        # @option arguments [String] :transform_id A transform identifier or a wildcard expression.
        #  If you do not specify one of these options, the API returns information for all transforms.
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request: contains wildcard expressions and there are no transforms that match; contains the `_all` string or no identifiers and there are no matches; contains wildcard expressions and there are only partial matches.
        #  If `true`, it returns an empty transforms array when there are no matches and the subset of results when there are partial matches.
        #  If `false`, the request returns a 404 status code when there are no matches or only partial matches. Server default: true.
        # @option arguments [Integer] :from Skips the specified number of transforms. Server default: 0.
        # @option arguments [String, Array<String>] :h Comma-separated list of column names to display. Server default: changes_last_detection_time,checkpoint,checkpoint_progress,documents_processed,id,last_search_time,state.
        # @option arguments [String, Array<String>] :s Comma-separated list of column names or column aliases used to sort the response.
        # @option arguments [String] :time The unit used to display time values.
        # @option arguments [Integer] :size The maximum number of transforms to obtain. Server default: 100.
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  `text`, `json`, `cbor`, `yaml`, or `smile`. Server default: text.
        # @option arguments [Boolean] :help When set to `true` will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to `true` will enable verbose output.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String] :filter_path Comma-separated list of filters in dot notation which reduce the response
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-cat-transforms
        #
        def transforms(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.transforms' }

          defined_params = [:transform_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _transform_id
                     "_cat/transforms/#{Utils.listify(_transform_id)}"
                   else
                     '_cat/transforms'
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
