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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Actions
      # Create a new document in the index.
      # You can index a new JSON document with the `/<target>/_doc/` or `/<target>/_create/<_id>` APIs
      # Using `_create` guarantees that the document is indexed only if it does not already exist.
      # It returns a 409 response when a document with a same ID already exists in the index.
      # To update an existing document, you must use the `/<target>/_doc/` API.
      # If the Elasticsearch security features are enabled, you must have the following index privileges for the target data stream, index, or index alias:
      # * To add a document using the `PUT /<target>/_create/<_id>` or `POST /<target>/_create/<_id>` request formats, you must have the `create_doc`, `create`, `index`, or `write` index privilege.
      # * To automatically create a data stream or index with this API request, you must have the `auto_configure`, `create_index`, or `manage` index privilege.
      # Automatic data stream creation requires a matching index template with data stream enabled.
      # **Automatically create data streams and indices**
      # If the request's target doesn't exist and matches an index template with a `data_stream` definition, the index operation automatically creates the data stream.
      # If the target doesn't exist and doesn't match a data stream template, the operation automatically creates the index and applies any matching index templates.
      # NOTE: Elasticsearch includes several built-in index templates. To avoid naming collisions with these templates, refer to index pattern documentation.
      # If no mapping exists, the index operation creates a dynamic mapping.
      # By default, new fields and objects are automatically added to the mapping if needed.
      # Automatic index creation is controlled by the `action.auto_create_index` setting.
      # If it is `true`, any index can be created automatically.
      # You can modify this setting to explicitly allow or block automatic creation of indices that match specified patterns or set it to `false` to turn off automatic index creation entirely.
      # Specify a comma-separated list of patterns you want to allow or prefix each pattern with `+` or `-` to indicate whether it should be allowed or blocked.
      # When a list is specified, the default behaviour is to disallow.
      # NOTE: The `action.auto_create_index` setting affects the automatic creation of indices only.
      # It does not affect the creation of data streams.
      # **Routing**
      # By default, shard placement — or routing — is controlled by using a hash of the document's ID value.
      # For more explicit control, the value fed into the hash function used by the router can be directly specified on a per-operation basis using the `routing` parameter.
      # When setting up explicit mapping, you can also use the `_routing` field to direct the index operation to extract the routing value from the document itself.
      # This does come at the (very minimal) cost of an additional document parsing pass.
      # If the `_routing` mapping is defined and set to be required, the index operation will fail if no routing value is provided or extracted.
      # NOTE: Data streams do not support custom routing unless they were created with the `allow_custom_routing` setting enabled in the template.
      # **Distributed**
      # The index operation is directed to the primary shard based on its route and performed on the actual node containing this shard.
      # After the primary shard completes the operation, if needed, the update is distributed to applicable replicas.
      # **Active shards**
      # To improve the resiliency of writes to the system, indexing operations can be configured to wait for a certain number of active shard copies before proceeding with the operation.
      # If the requisite number of active shard copies are not available, then the write operation must wait and retry, until either the requisite shard copies have started or a timeout occurs.
      # By default, write operations only wait for the primary shards to be active before proceeding (that is to say `wait_for_active_shards` is `1`).
      # This default can be overridden in the index settings dynamically by setting `index.write.wait_for_active_shards`.
      # To alter this behavior per operation, use the `wait_for_active_shards request` parameter.
      # Valid values are all or any positive integer up to the total number of configured copies per shard in the index (which is `number_of_replicas`+1).
      # Specifying a negative value or a number greater than the number of shard copies will throw an error.
      # For example, suppose you have a cluster of three nodes, A, B, and C and you create an index index with the number of replicas set to 3 (resulting in 4 shard copies, one more copy than there are nodes).
      # If you attempt an indexing operation, by default the operation will only ensure the primary copy of each shard is available before proceeding.
      # This means that even if B and C went down and A hosted the primary shard copies, the indexing operation would still proceed with only one copy of the data.
      # If `wait_for_active_shards` is set on the request to `3` (and all three nodes are up), the indexing operation will require 3 active shard copies before proceeding.
      # This requirement should be met because there are 3 active nodes in the cluster, each one holding a copy of the shard.
      # However, if you set `wait_for_active_shards` to `all` (or to `4`, which is the same in this situation), the indexing operation will not proceed as you do not have all 4 copies of each shard active in the index.
      # The operation will timeout unless a new node is brought up in the cluster to host the fourth copy of the shard.
      # It is important to note that this setting greatly reduces the chances of the write operation not writing to the requisite number of shard copies, but it does not completely eliminate the possibility, because this check occurs before the write operation starts.
      # After the write operation is underway, it is still possible for replication to fail on any number of shard copies but still succeed on the primary.
      # The `_shards` section of the API response reveals the number of shard copies on which replication succeeded and failed.
      #
      # @option arguments [String] :id A unique identifier for the document.
      #  To automatically generate a document ID, use the `POST /<target>/_doc/` request format. (*Required*)
      # @option arguments [String] :index The name of the data stream or index to target.
      #  If the target doesn't exist and matches the name or wildcard (`*`) pattern of an index template with a `data_stream` definition, this request creates the data stream.
      #  If the target doesn't exist and doesn’t match a data stream template, this request creates the index. (*Required*)
      # @option arguments [Boolean] :include_source_on_error True or false if to include the document source in the error message in case of parsing errors. Server default: true.
      # @option arguments [String] :pipeline The ID of the pipeline to use to preprocess incoming documents.
      #  If the index has a default ingest pipeline specified, setting the value to `_none` turns off the default ingest pipeline for this request.
      #  If a final pipeline is configured, it will always run regardless of the value of this parameter.
      # @option arguments [String] :refresh If `true`, Elasticsearch refreshes the affected shards to make this operation visible to search.
      #  If `wait_for`, it waits for a refresh to make this operation visible to search.
      #  If `false`, it does nothing with refreshes. Server default: false.
      # @option arguments [Boolean] :require_alias If `true`, the destination must be an index alias.
      # @option arguments [Boolean] :require_data_stream If `true`, the request's actions must target a data stream (existing or to be created).
      # @option arguments [String] :routing A custom value that is used to route operations to a specific shard.
      # @option arguments [Time] :timeout The period the request waits for the following operations: automatic index creation, dynamic mapping updates, waiting for active shards.
      #  Elasticsearch waits for at least the specified timeout period before failing.
      #  The actual wait time could be longer, particularly when multiple waits occur.This parameter is useful for situations where the primary shard assigned to perform the operation might not be available when the operation runs.
      #  Some reasons for this might be that the primary shard is currently recovering from a gateway or undergoing relocation.
      #  By default, the operation will wait on the primary shard to become available for at least 1 minute before failing and responding with an error.
      #  The actual wait time could be longer, particularly when multiple waits occur. Server default: 1m.
      # @option arguments [Integer] :version The explicit version number for concurrency control.
      #  It must be a non-negative long number.
      # @option arguments [String] :version_type The version type.
      # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
      #  You can set it to `all` or any positive integer up to the total number of shards in the index (`number_of_replicas+1`).
      #  The default value of `1` means it waits for each primary shard to be active. Server default: 1.
      # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
      #  when they occur.
      # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
      #  returned by Elasticsearch.
      # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
      #  For example `"exists_time": "1h"` for humans and
      #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
      #  readable values will be omitted. This makes sense for responses being consumed
      #  only by machines.
      # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
      #  this option for debugging only.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body document
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-create
      #
      def create(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'create' }

        defined_params = [:index, :id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_PUT
        path   = "#{Utils.listify(_index)}/_create/#{Utils.listify(_id)}"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
