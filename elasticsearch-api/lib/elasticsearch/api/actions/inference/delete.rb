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
    module Inference
      module Actions
        # Delete an inference endpoint
        #
        # @option arguments [String] :task_type The task type
        # @option arguments [String] :inference_id The inference identifier. (*Required*)
        # @option arguments [Boolean] :dry_run When true, the endpoint is not deleted and a list of ingest processors which reference this endpoint is returned.
        # @option arguments [Boolean] :force When true, the inference endpoint is forcefully deleted even if it is still being used by ingest processors or semantic text fields.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-inference-delete
        #
        def delete(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'inference.delete' }

          defined_params = [:inference_id, :task_type].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'inference_id' missing" unless arguments[:inference_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _task_type = arguments.delete(:task_type)

          _inference_id = arguments.delete(:inference_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = if _task_type && _inference_id
                     "_inference/#{Utils.listify(_task_type)}/#{Utils.listify(_inference_id)}"
                   else
                     "_inference/#{Utils.listify(_inference_id)}"
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
