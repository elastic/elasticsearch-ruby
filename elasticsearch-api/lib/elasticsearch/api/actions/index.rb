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
      # Create or update a document in an index.
      # Add a JSON document to the specified data stream or index and make it searchable.
      # If the target is an index and the document already exists, the request updates the document and increments its version.
      # NOTE: You cannot use this API to send update requests for existing documents in a data stream.
      # If the Elasticsearch security features are enabled, you must have the following index privileges for the target data stream, index, or index alias:
      # * To add or overwrite a document using the +PUT /<target>/_doc/<_id>+ request format, you must have the +create+, +index+, or +write+ index privilege.
      # * To add a document using the +POST /<target>/_doc/+ request format, you must have the +create_doc+, +create+, +index+, or +write+ index privilege.
      # * To automatically create a data stream or index with this API request, you must have the +auto_configure+, +create_index+, or +manage+ index privilege.
      # Automatic data stream creation requires a matching index template with data stream enabled.
      # NOTE: Replica shards might not all be started when an indexing operation returns successfully.
      # By default, only the primary is required. Set +wait_for_active_shards+ to change this default behavior.
      # **Automatically create data streams and indices**
      # If the request's target doesn't exist and matches an index template with a +data_stream+ definition, the index operation automatically creates the data stream.
      # If the target doesn't exist and doesn't match a data stream template, the operation automatically creates the index and applies any matching index templates.
      # NOTE: Elasticsearch includes several built-in index templates. To avoid naming collisions with these templates, refer to index pattern documentation.
      # If no mapping exists, the index operation creates a dynamic mapping.
      # By default, new fields and objects are automatically added to the mapping if needed.
      # Automatic index creation is controlled by the +action.auto_create_index+ setting.
      # If it is +true+, any index can be created automatically.
      # You can modify this setting to explicitly allow or block automatic creation of indices that match specified patterns or set it to +false+ to turn off automatic index creation entirely.
      # Specify a comma-separated list of patterns you want to allow or prefix each pattern with +++ or +-+ to indicate whether it should be allowed or blocked.
      # When a list is specified, the default behaviour is to disallow.
      # NOTE: The +action.auto_create_index+ setting affects the automatic creation of indices only.
      # It does not affect the creation of data streams.
      # **Optimistic concurrency control**
      # Index operations can be made conditional and only be performed if the last modification to the document was assigned the sequence number and primary term specified by the +if_seq_no+ and +if_primary_term+ parameters.
      # If a mismatch is detected, the operation will result in a +VersionConflictException+ and a status code of +409+.
      # **Routing**
      # By default, shard placement — or routing — is controlled by using a hash of the document's ID value.
      # For more explicit control, the value fed into the hash function used by the router can be directly specified on a per-operation basis using the +routing+ parameter.
      # When setting up explicit mapping, you can also use the +_routing+ field to direct the index operation to extract the routing value from the document itself.
      # This does come at the (very minimal) cost of an additional document parsing pass.
      # If the +_routing+ mapping is defined and set to be required, the index operation will fail if no routing value is provided or extracted.
      # NOTE: Data streams do not support custom routing unless they were created with the +allow_custom_routing+ setting enabled in the template.
      # **Distributed**
      # The index operation is directed to the primary shard based on its route and performed on the actual node containing this shard.
      # After the primary shard completes the operation, if needed, the update is distributed to applicable replicas.
      # **Active shards**
      # To improve the resiliency of writes to the system, indexing operations can be configured to wait for a certain number of active shard copies before proceeding with the operation.
      # If the requisite number of active shard copies are not available, then the write operation must wait and retry, until either the requisite shard copies have started or a timeout occurs.
      # By default, write operations only wait for the primary shards to be active before proceeding (that is to say +wait_for_active_shards+ is +1+).
      # This default can be overridden in the index settings dynamically by setting +index.write.wait_for_active_shards+.
      # To alter this behavior per operation, use the +wait_for_active_shards request+ parameter.
      # Valid values are all or any positive integer up to the total number of configured copies per shard in the index (which is +number_of_replicas++1).
      # Specifying a negative value or a number greater than the number of shard copies will throw an error.
      # For example, suppose you have a cluster of three nodes, A, B, and C and you create an index index with the number of replicas set to 3 (resulting in 4 shard copies, one more copy than there are nodes).
      # If you attempt an indexing operation, by default the operation will only ensure the primary copy of each shard is available before proceeding.
      # This means that even if B and C went down and A hosted the primary shard copies, the indexing operation would still proceed with only one copy of the data.
      # If +wait_for_active_shards+ is set on the request to +3+ (and all three nodes are up), the indexing operation will require 3 active shard copies before proceeding.
      # This requirement should be met because there are 3 active nodes in the cluster, each one holding a copy of the shard.
      # However, if you set +wait_for_active_shards+ to +all+ (or to +4+, which is the same in this situation), the indexing operation will not proceed as you do not have all 4 copies of each shard active in the index.
      # The operation will timeout unless a new node is brought up in the cluster to host the fourth copy of the shard.
      # It is important to note that this setting greatly reduces the chances of the write operation not writing to the requisite number of shard copies, but it does not completely eliminate the possibility, because this check occurs before the write operation starts.
      # After the write operation is underway, it is still possible for replication to fail on any number of shard copies but still succeed on the primary.
      # The +_shards+ section of the API response reveals the number of shard copies on which replication succeeded and failed.
      # **No operation (noop) updates**
      # When updating a document by using this API, a new version of the document is always created even if the document hasn't changed.
      # If this isn't acceptable use the +_update+ API with +detect_noop+ set to +true+.
      # The +detect_noop+ option isn't available on this API because it doesn’t fetch the old source and isn't able to compare it against the new source.
      # There isn't a definitive rule for when noop updates aren't acceptable.
      # It's a combination of lots of factors like how frequently your data source sends updates that are actually noops and how many queries per second Elasticsearch runs on the shard receiving the updates.
      # **Versioning**
      # Each indexed document is given a version number.
      # By default, internal versioning is used that starts at 1 and increments with each update, deletes included.
      # Optionally, the version number can be set to an external value (for example, if maintained in a database).
      # To enable this functionality, +version_type+ should be set to +external+.
      # The value provided must be a numeric, long value greater than or equal to 0, and less than around +9.2e+18+.
      # NOTE: Versioning is completely real time, and is not affected by the near real time aspects of search operations.
      # If no version is provided, the operation runs without any version checks.
      # When using the external version type, the system checks to see if the version number passed to the index request is greater than the version of the currently stored document.
      # If true, the document will be indexed and the new version number used.
      # If the value provided is less than or equal to the stored document's version number, a version conflict will occur and the index operation will fail. For example:
      # ```
      # PUT my-index-000001/_doc/1?version=2&version_type=external
      # {
      #   "user": {
      #     "id": "elkbee"
      #   }
      # }
      # In this example, the operation will succeed since the supplied version of 2 is higher than the current document version of 1.
      # If the document was already updated and its version was set to 2 or higher, the indexing command will fail and result in a conflict (409 HTTP status code).
      # A nice side effect is that there is no need to maintain strict ordering of async indexing operations run as a result of changes to a source database, as long as version numbers from the source database are used.
      # Even the simple case of updating the Elasticsearch index using data from a database is simplified if external versioning is used, as only the latest version will be used if the index operations arrive out of order.
      #
      # @option arguments [String] :id A unique identifier for the document.
      #  To automatically generate a document ID, use the +POST /<target>/_doc/+ request format and omit this parameter.
      # @option arguments [String] :index The name of the data stream or index to target.
      #  If the target doesn't exist and matches the name or wildcard (+*+) pattern of an index template with a +data_stream+ definition, this request creates the data stream.
      #  If the target doesn't exist and doesn't match a data stream template, this request creates the index.
      #  You can check for existing targets with the resolve index API. (*Required*)
      # @option arguments [Integer] :if_primary_term Only perform the operation if the document has this primary term.
      # @option arguments [Integer] :if_seq_no Only perform the operation if the document has this sequence number.
      # @option arguments [Boolean] :include_source_on_error True or false if to include the document source in the error message in case of parsing errors. Server default: true.
      # @option arguments [String] :op_type Set to +create+ to only index the document if it does not already exist (put if absent).
      #  If a document with the specified +_id+ already exists, the indexing operation will fail.
      #  The behavior is the same as using the +<index>/_create+ endpoint.
      #  If a document ID is specified, this paramater defaults to +index+.
      #  Otherwise, it defaults to +create+.
      #  If the request targets a data stream, an +op_type+ of +create+ is required.
      # @option arguments [String] :pipeline The ID of the pipeline to use to preprocess incoming documents.
      #  If the index has a default ingest pipeline specified, then setting the value to +_none+ disables the default ingest pipeline for this request.
      #  If a final pipeline is configured it will always run, regardless of the value of this parameter.
      # @option arguments [String] :refresh If +true+, Elasticsearch refreshes the affected shards to make this operation visible to search.
      #  If +wait_for+, it waits for a refresh to make this operation visible to search.
      #  If +false+, it does nothing with refreshes. Server default: false.
      # @option arguments [String] :routing A custom value that is used to route operations to a specific shard.
      # @option arguments [Time] :timeout The period the request waits for the following operations: automatic index creation, dynamic mapping updates, waiting for active shards.This parameter is useful for situations where the primary shard assigned to perform the operation might not be available when the operation runs.
      #  Some reasons for this might be that the primary shard is currently recovering from a gateway or undergoing relocation.
      #  By default, the operation will wait on the primary shard to become available for at least 1 minute before failing and responding with an error.
      #  The actual wait time could be longer, particularly when multiple waits occur. Server default: 1m.
      # @option arguments [Integer] :version An explicit version number for concurrency control.
      #  It must be a non-negative long number.
      # @option arguments [String] :version_type The version type.
      # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
      #  You can set it to +all+ or any positive integer up to the total number of shards in the index (+number_of_replicas+1+).
      #  The default value of +1+ means it waits for each primary shard to be active. Server default: 1.
      # @option arguments [Boolean] :require_alias If +true+, the destination must be an index alias.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body document
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-create
      #
      def index(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'index' }

        defined_params = [:index, :id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = _id ? Elasticsearch::API::HTTP_PUT : Elasticsearch::API::HTTP_POST
        path   = if _index && _id
                   "#{Utils.listify(_index)}/_doc/#{Utils.listify(_id)}"
                 else
                   "#{Utils.listify(_index)}/_doc"
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
