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

      # Returns information and statistics about terms in the fields of multiple documents
      # in a single request/response. The semantics are similar to the {#mget} API.
      #
      # @example Return information about multiple documents in a specific index
      #
      #     subject.mtermvectors index: 'my-index', type: 'my-type', body: { ids: [1, 2, 3] }
      #
      # @option arguments [String] :index The index in which the document resides.
      # @option arguments [String] :type The type of the document.
      # @option arguments [Hash] :body Define ids, documents, parameters or a list of parameters per document here. You must at least provide a list of document ids. See documentation.
      # @option arguments [List] :ids A comma-separated list of documents ids. You must define ids as parameter or set "ids" or "docs" in the request body
      # @option arguments [Boolean] :term_statistics Specifies if total term frequency and document frequency should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :field_statistics Specifies if document count, sum of document frequencies and sum of total term frequencies should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [List] :fields A comma-separated list of fields to return. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :offsets Specifies if term offsets should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :positions Specifies if term positions should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :payloads Specifies if term payloads should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random) .Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [String] :routing Specific routing value. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [String] :parent Parent id of documents. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :realtime Specifies if requests are real-time as opposed to near-real-time (default: true).
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-multi-termvectors.html
      #
      # @see #mget
      # @see #termvector
      #
      def mtermvectors(arguments={})
        ids = arguments.delete(:ids)

        method = HTTP_GET
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 '_mtermvectors'

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        if ids
          body = { :ids => ids }
        else
          body = arguments[:body]
        end

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:mtermvectors, [
          :ids,
          :term_statistics,
          :field_statistics,
          :fields,
          :offsets,
          :positions,
          :payloads,
          :preference,
          :routing,
          :parent,
          :realtime,
          :version,
          :version_type ].freeze)
    end
  end
end
