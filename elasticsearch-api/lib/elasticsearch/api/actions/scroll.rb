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
    module Actions
      # Run a scrolling search.
      # IMPORTANT: The scroll API is no longer recommend for deep pagination. If you need to preserve the index state while paging through more than 10,000 hits, use the +search_after+ parameter with a point in time (PIT).
      # The scroll API gets large sets of results from a single scrolling search request.
      # To get the necessary scroll ID, submit a search API request that includes an argument for the +scroll+ query parameter.
      # The +scroll+ parameter indicates how long Elasticsearch should retain the search context for the request.
      # The search response returns a scroll ID in the +_scroll_id+ response body parameter.
      # You can then use the scroll ID with the scroll API to retrieve the next batch of results for the request.
      # If the Elasticsearch security features are enabled, the access to the results of a specific scroll ID is restricted to the user or API key that submitted the search.
      # You can also use the scroll API to specify a new scroll parameter that extends or shortens the retention period for the search context.
      # IMPORTANT: Results from a scrolling search reflect the state of the index at the time of the initial search request. Subsequent indexing or document changes only affect later search and scroll requests.
      #
      # @option arguments [String] :scroll_id The scroll ID
      # @option arguments [Time] :scroll The period to retain the search context for scrolling. Server default: 1d.
      # @option arguments [Boolean] :rest_total_hits_as_int If true, the API response’s hit.total property is returned as an integer. If false, the API response’s hit.total property is returned as an object.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # *Deprecation notice*:
      # A scroll id can be quite large and should be specified as part of the body
      # Deprecated since version 7.0.0
      #
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-scroll
      #
      def scroll(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'scroll' }

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _scroll_id = arguments.delete(:scroll_id)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = '_search/scroll'
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
