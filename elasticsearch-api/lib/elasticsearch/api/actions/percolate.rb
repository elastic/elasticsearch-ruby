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

      # Return names of queries matching a document.
      #
      # Percolator allows you to register queries and then evaluate a document against them:
      # the IDs of matching queries are returned in the response.
      #
      # @deprecated The `_percolate` API has been deprecated in favour of a special field mapping and the
      #             `percolate` query;
      #             see https://www.elastic.co/guide/en/elasticsearch/reference/5.5/breaking_50_percolator.html
      #
      # See full example for Elasticsearch 5.x and higher in <https://github.com/elastic/elasticsearch-ruby/blob/master/examples/percolator/percolator_alerts.rb>
      #
      # @option arguments [String] :index The index of the document being percolated. (*Required*)
      # @option arguments [String] :type The type of the document being percolated. (*Required*)
      # @option arguments [String] :id Fetch the document specified by index/type/id and
      #                                use it instead of the passed `doc`
      # @option arguments [Hash] :body The percolator request definition using the percolate DSL
      # @option arguments [List] :routing A comma-separated list of specific routing values
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when
      #                                                 unavailable (missing or closed)
      # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into
      #                                               no concrete indices. (This includes `_all` string or when no
      #                                               indices have been specified)
      # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are
      #                                              open, closed or both. (options: open, closed)
      # @option arguments [String] :percolate_index The index to percolate the document into. Defaults to passed `index`.
      # @option arguments [String] :percolate_format Return an array of matching query IDs instead of objects.
      #                                              (options: ids)
      # @option arguments [String] :percolate_type The type to percolate document into. Defaults to passed `type`.
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-percolate.html
      #
      def percolate(arguments={})
        Utils.__report_unsupported_method :percolate

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing"  unless arguments[:type]
        method = HTTP_GET
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id]),
                                 '_percolate'

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:percolate, [
          :routing,
          :preference,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :percolate_index,
          :percolate_type,
          :percolate_format,
          :version,
          :version_type ].freeze)
    end
  end
end
