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
    module Transform
      module Actions
        # Stop transforms.
        # Stops one or more transforms.
        #
        # @option arguments [String] :transform_id Identifier for the transform. To stop multiple transforms, use a comma-separated list or a wildcard expression.
        #  To stop all transforms, use `_all` or `*` as the identifier. (*Required*)
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request: contains wildcard expressions and there are no transforms that match;
        #  contains the `_all` string or no identifiers and there are no matches; contains wildcard expressions and there
        #  are only partial matches.If it is true, the API returns a successful acknowledgement message when there are no matches. When there are
        #  only partial matches, the API stops the appropriate transforms.If it is false, the request returns a 404 status code when there are no matches or only partial matches. Server default: true.
        # @option arguments [Boolean] :force If it is true, the API forcefully stops the transforms.
        # @option arguments [Time] :timeout Period to wait for a response when `wait_for_completion` is `true`. If no response is received before the
        #  timeout expires, the request returns a timeout exception. However, the request continues processing and
        #  eventually moves the transform to a STOPPED state. Server default: 30s.
        # @option arguments [Boolean] :wait_for_checkpoint If it is true, the transform does not completely stop until the current checkpoint is completed. If it is false,
        #  the transform stops as soon as possible.
        # @option arguments [Boolean] :wait_for_completion If it is true, the API blocks until the indexer state completely stops. If it is false, the API returns
        #  immediately and the indexer is stopped asynchronously in the background.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-transform-stop-transform
        #
        def stop_transform(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'transform.stop_transform' }

          defined_params = [:transform_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_transform/#{Utils.listify(_transform_id)}/_stop"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
