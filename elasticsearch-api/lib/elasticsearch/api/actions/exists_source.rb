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

      # The get API allows to get a typed JSON document from the index based on its id.
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document; use `_all` to fetch the first document matching the ID across all types (*Required*)
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      # @option arguments [List] :_source True or false to return the _source field or not, or a list of fields to return
      # @option arguments [List] :_source_excludes A list of fields to exclude from the returned _source field
      # @option arguments [List] :_source_includes A list of fields to extract and return from the _source field
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      #
      # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/docs-get.html
      #
      def exists_source(arguments={})
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'type' missing" unless arguments[:type]
        method = Elasticsearch::API::HTTP_HEAD
        path   = "#{arguments[:index]}/#{arguments[:type]}/#{arguments[:id]}/_source"
        params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = nil

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:exists_source, [
          :parent,
          :preference,
          :realtime,
          :refresh,
          :routing,
          :_source,
          :_source_excludes,
          :_source_includes,
          :version,
          :version_type ].freeze)
    end
  end
end
