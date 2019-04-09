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

      # Create or update a document.
      #
      # The `index` API will either _create_ a new document, or _update_ an existing one, when a document `:id`
      # is passed. When creating a document, an ID will be auto-generated, when it's not passed as an argument.
      #
      # You can specifically enforce the _create_ operation by setting the `op_type` argument to `create`, or
      # by using the {Actions#create} method.
      #
      # Optimistic concurrency control is performed, when the `version` argument is specified. By default,
      # no version checks are performed.
      #
      # By default, the document will be available for {Actions#get} immediately, for {Actions#search} only
      # after an index refresh operation has been performed (either automatically or manually).
      #
      # @example Create or update a document `myindex/mytype/1`
      #
      #     client.index index: 'myindex',
      #                  type: 'mytype',
      #                  id: '1',
      #                  body: {
      #                   title: 'Test 1',
      #                   tags: ['y', 'z'],
      #                   published: true,
      #                   published_at: Time.now.utc.iso8601,
      #                   counter: 1
      #                 }
      #
      # @example Refresh the index after the operation (useful e.g. in integration tests)
      #
      #     client.index index: 'myindex', type: 'mytype', id: '1', body: { title: 'TEST' }, refresh: true
      #     client.search index: 'myindex', q: 'title:test'
      #
      # @example Create a document with a specific expiration time (TTL)
      #
      #     # Decrease the default housekeeping interval first:
      #     client.cluster.put_settings body: { transient: { 'indices.ttl.interval' => '1s' } }
      #
      #     # Enable the `_ttl` property for all types within the index
      #     client.indices.create index: 'myindex', body: { mappings: { properties: { _ttl: { enabled: true } }  } }
      #
      #     client.index index: 'myindex', type: 'mytype', id: '1', body: { title: 'TEST' }, ttl: '5s'
      #
      #     sleep 3 and client.get index: 'myindex', type: 'mytype', id: '1'
      #     # => {"_index"=>"myindex" ... "_source"=>{"title"=>"TEST"}}
      #
      #     sleep 3 and client.get index: 'myindex', type: 'mytype', id: '1'
      #     # => Elasticsearch::Transport::Transport::Errors::NotFound: [404] ...
      #
      # @option arguments [String] :id Document ID (optional, will be auto-generated if missing)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [Hash] :body The document
      # @option arguments [String] :consistency Explicit write consistency setting for the operation
      #                                         (options: one, quorum, all)
      # @option arguments [Boolean] :include_type_name Whether a type should be expected in the body of the mappings.
      # @option arguments [String] :op_type Explicit operation type (options: index, create)
      # @option arguments [String] :parent ID of the parent document
      # @option arguments [String] :percolate Percolator queries to execute while indexing the document
      # @option arguments [Boolean] :refresh Refresh the index after performing the operation
      # @option arguments [String] :replication Specific replication type (options: sync, async)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Time] :timestamp Explicit timestamp for the document
      # @option arguments [Duration] :ttl Expiration time for the document
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte, force)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html
      #
      def index(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        arguments[:type] ||= DEFAULT_DOC
        method = arguments[:id] ? HTTP_PUT : HTTP_POST
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id])

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]
        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:index, [
          :consistency,
          :include_type_name,
          :op_type,
          :parent,
          :percolate,
          :pipeline,
          :refresh,
          :replication,
          :routing,
          :timeout,
          :timestamp,
          :ttl,
          :version,
          :version_type,
          :if_seq_no,
          :if_primary_term ].freeze)
    end
  end
end
