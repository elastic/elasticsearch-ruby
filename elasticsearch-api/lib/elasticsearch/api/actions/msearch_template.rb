# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Actions

      # Execute several search requests using templates (inline, indexed or stored in a file)
      #
      # @example Search with an inline script
      #
      #     client.msearch_template body: [
      #       { index: 'test' },
      #       { inline: { query: { match: { title: '{{q}}' } } }, params: { q: 'foo'} }
      #     ]
      #
      # @option arguments [List] :index A comma-separated list of index names to use as default
      # @option arguments [List] :type A comma-separated list of document types to use as default
      # @option arguments [Hash] :body The request definitions (metadata-search request definition pairs), separated by newlines (*Required*)
      # @option arguments [String] :search_type Search operation type (options: query_then_fetch, query_and_fetch, dfs_query_then_fetch, dfs_query_and_fetch)
      # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
      # @option arguments [Number] :max_concurrent_searches Controls the maximum number of concurrent searches the multi search api will execute
      # @option arguments [Boolean] :rest_total_hits_as_int Indicates whether hits.total should be rendered as an integer or an object in the rest search response
      # @option arguments [Boolean] :ccs_minimize_roundtrips Indicates whether network round-trips should be minimized as part of cross-cluster search requests execution
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-search-template.html
      #
      def msearch_template(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = HTTP_GET
        path   = Utils.__pathify Utils.__listify(arguments[:index]),
                                 Utils.__listify(arguments[:type]),
                                 '_msearch/template'
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        case
          when body.is_a?(Array)
            payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
            payload << "" unless payload.empty?
            payload = payload.join("\n")
          else
            payload = body
        end

        perform_request(method, path, params, payload, {"Content-Type" => "application/x-ndjson"}).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:msearch_template, [
          :search_type,
          :typed_keys,
          :max_concurrent_searches,
          :rest_total_hits_as_int,
          :ccs_minimize_roundtrips ].freeze)
    end
  end
end
