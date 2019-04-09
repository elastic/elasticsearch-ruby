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

      # Return multiple documents from one or more indices in a single request.
      #
      # Pass the request definition in the `:body` argument, either as an Array of `docs` specifications,
      # or `ids`, when the `:index` and document `:type` are specified.
      #
      # @example Get multiple documents fully specified in the `docs` definition
      #
      #     client.mget body: {
      #       docs: [
      #         { _index: 'myindex', _type: 'mytype', _id: '1' },
      #         { _index: 'myindex', _type: 'mytype', _id: '2' },
      #         { _index: 'myindex', _type: 'mytype', _id: '3' }
      #       ]
      #     }
      #
      # @example Get multiple documents specified by `ids` while passing `:index` and `:type`
      #
      #     client.mget index: 'myindex', type: 'mytype', body: { ids: ['1', '2', '3'] }
      #
      # @example Get only specific fields from documents
      #
      #     client.mget index: 'myindex', type: 'mytype', body: { ids: ['1', '2', '3'] }, fields: ['title']
      #
      # @option arguments [String] :index The name of the index
      # @option arguments [String] :type The type of the document
      # @option arguments [Hash] :body Document identifiers; can be either `docs` (containing full document information) or `ids` (when index and type is provided in the URL. (*Required*)
      # @option arguments [List] :stored_fields A comma-separated list of stored fields to return in the response
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field
      #
      # @see http://elasticsearch.org/guide/reference/api/multi-get/
      #
      def mget(arguments={})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = HTTP_GET
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 '_mget'

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:mget, [
          :stored_fields,
          :preference,
          :realtime,
          :refresh,
          :routing,
          :_source,
          :_source_excludes,
          :_source_includes ].freeze)
    end
  end
end
