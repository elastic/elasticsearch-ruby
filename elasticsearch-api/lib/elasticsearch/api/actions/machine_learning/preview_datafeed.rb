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
        # Preview a datafeed.
        # This API returns the first "page" of search results from a datafeed.
        # You can preview an existing datafeed or provide configuration details for a datafeed
        # and anomaly detection job in the API. The preview shows the structure of the data
        # that will be passed to the anomaly detection engine.
        # IMPORTANT: When Elasticsearch security features are enabled, the preview uses the credentials of the user that
        # called the API. However, when the datafeed starts it uses the roles of the last user that created or updated the
        # datafeed. To get a preview that accurately reflects the behavior of the datafeed, use the appropriate credentials.
        # You can also use secondary authorization headers to supply the credentials.
        #
        # @option arguments [String] :datafeed_id A numerical character string that uniquely identifies the datafeed. This identifier can contain lowercase
        #  alphanumeric characters (a-z and 0-9), hyphens, and underscores. It must start and end with alphanumeric
        #  characters. NOTE: If you use this path parameter, you cannot provide datafeed or anomaly detection job
        #  configuration details in the request body.
        # @option arguments [String, Time] :start The start time from where the datafeed preview should begin
        # @option arguments [String, Time] :end The end time when the datafeed preview should stop
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
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-preview-datafeed
        #
        def preview_datafeed(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.preview_datafeed' }

          defined_params = [:datafeed_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _datafeed_id = arguments.delete(:datafeed_id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = if _datafeed_id
                     "_ml/datafeeds/#{Utils.listify(_datafeed_id)}/_preview"
                   else
                     '_ml/datafeeds/_preview'
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
