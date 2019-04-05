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

      # Update a document without sending the whole document in the request ("partial update").
      #
      # Send either a partial document (`doc` ) which will be deeply merged into an existing document,
      # or a `script`, which will update the document content, in the `:body` argument.
      #
      # The partial update operation allows you to limit the amount of data you send over the wire and
      # reduces the chance of failed updates due to conflict.
      #
      # Specify the `:version` and `:retry_on_conflict` arguments to balance convenience and consistency.
      #
      # @example Update document _title_ using partial `doc`-ument
      #
      #     client.update index: 'myindex', type: 'mytype', id: '1',
      #                   body: { doc: { title: 'Updated' } }
      #
      # @example Add a tag to document `tags` property using a `script`
      #
      #     client.update index: 'myindex', type: 'mytype', id: '1',
      #                    body: { script: { source: 'ctx._source.tags.add(params.tag)', params: { tag: 'x' } } }
      #
      # @example Increment a document counter by 1 _or_ initialize it, when the document does not exist
      #
      #     client.update index: 'myindex', type: 'mytype', id: '666',
      #                   body: { script: 'ctx._source.counter += 1', upsert: { counter: 1 } }
      #
      # @example Delete a document if it's tagged "to-delete"
      #
      #     client.update index: 'myindex', type: 'mytype', id: '1',
      #                   body: { script: 'ctx._source.tags.contains(params.tag) ? ctx.op = "delete" : ctx.op = "none"',
      #                           params: { tag: 'to-delete' } }
      #
      # @option arguments [String] :id Document ID (*Required*)
      # @option arguments [Number,List] :ignore The list of HTTP errors to ignore; only `404` supported at the moment
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (*Required*)
      # @option arguments [Hash] :body The request definition using either `script` or partial `doc` (*Required*)
      # @option arguments [String] :consistency Explicit write consistency setting for the operation
      #                                         (options: one, quorum, all)
      # @option arguments [List] :fields A comma-separated list of fields to return in the response
      # @option arguments [Boolean] :include_type_name Whether a type should be expected in the body of the mappings.
      # @option arguments [String] :lang The script language (default: mvel)
      # @option arguments [String] :parent ID of the parent document
      # @option arguments [String] :percolate Perform percolation during the operation;
      #                                       use specific registered query name, attribute, or wildcard
      # @option arguments [Boolean] :refresh Refresh the index after performing the operation
      # @option arguments [String] :replication Specific replication type (options: sync, async)
      # @option arguments [Number] :retry_on_conflict Specify how many times should the operation be retried
      #                                               when a conflict occurs (default: 0)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [String] :script The URL-encoded script definition (instead of using request body)
      # @option arguments [String] :_source Specify whether the _source field should be returned,
      #                                     or a list of fields to return
      # @option arguments [String] :_source_exclude A list of fields to exclude from the returned _source field
      # @option arguments [String] :_source_include A list of fields to extract and return from the _source field
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Time] :timestamp Explicit timestamp for the document
      # @option arguments [Duration] :ttl Expiration time for the document
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [Number] :version_type Explicit version number for concurrency control
      #
      # @since 0.20
      #
      # @see http://elasticsearch.org/guide/reference/api/update/
      #
      def update(arguments={})
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        arguments[:type] ||= DEFAULT_DOC
        method = HTTP_POST

        if arguments[:type]
          path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                   Utils.__escape(arguments[:type]),
                                   Utils.__escape(arguments[:id]),
                                   '_update'
        else
          path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                   '_update',
                                   Utils.__escape(arguments[:id])
        end

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]
        params[:fields] = Utils.__listify(params[:fields]) if params[:fields]

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
        else
          perform_request(method, path, params, body).body
        end
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.1.1
      ParamsRegistry.register(:update, [
          :consistency,
          :fields,
          :include_type_name,
          :lang,
          :parent,
          :percolate,
          :refresh,
          :replication,
          :retry_on_conflict,
          :routing,
          :script,
          :_source,
          :_source_include,
          :_source_exclude,
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
