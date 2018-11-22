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

      # Return query terms suggestions based on provided text and configuration.
      #
      # Pass the request definition in the `:body` argument.
      #
      # @deprecated The `_suggest` API has been deprecated in favour of using `_search` with
      #   suggest criteria in the body.
      #   Please see https://www.elastic.co/guide/en/elasticsearch/reference/6.0/search-suggesters.html
      #
      # @example Return query terms suggestions ("auto-correction")
      #
      #     client.suggest index: 'myindex',
      #                    body: { my_suggest: { text: 'tset', term: { field: 'title' } } }
      #     # => { ... "my_suggest"=>[ {"text"=>"tset", ... "options"=>[{"text"=>"test", "score"=>0.75, "freq"=>5}] }]}
      #
      # @option arguments [List] :index A comma-separated list of index names to restrict the operation;
      #                                 use `_all` or empty string to perform the operation on all indices
      # @option arguments [Hash] :body The request definition
      # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
      #                                            (options: none, missing)
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :source The URL-encoded request definition (instead of using request body)
      #
      # @since 0.90
      #
      # @see http://elasticsearch.org/guide/reference/api/search/suggest/
      #
      def suggest(arguments={})
        method = HTTP_POST
        path   = Utils.__pathify( Utils.__listify(arguments[:index]), '_suggest' )

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:suggest, [
          :ignore_indices,
          :preference,
          :routing,
          :source ].freeze)
    end
  end
end
