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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Actions
      # Explicitly clears the search context for a scroll.
      #
      # @option arguments [List] :scroll_id A comma-separated list of scroll IDs to clear *Deprecated*
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body A comma-separated list of scroll IDs to clear if none was specified via the scroll_id parameter
      #
      # *Deprecation notice*:
      # A scroll id can be quite large and should be specified as part of the body
      # Deprecated since version 7.0.0
      #
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/clear-scroll-api.html
      #
      def clear_scroll(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'clear_scroll' }

        defined_params = [:scroll_id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _scroll_id = arguments.delete(:scroll_id)

        method = Elasticsearch::API::HTTP_DELETE
        path   = if _scroll_id
                   "_search/scroll/#{Utils.__listify(_scroll_id)}"
                 else
                   '_search/scroll'
                 end
        params = Utils.process_params(arguments)

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found do
            Elasticsearch::API::Response.new(
              perform_request(method, path, params, body, headers, request_opts)
            )
          end
        else
          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
