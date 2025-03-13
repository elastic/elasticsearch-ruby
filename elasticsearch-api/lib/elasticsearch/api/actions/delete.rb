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
      # Delete a document.
      # Remove a JSON document from the specified index.
      # NOTE: You cannot send deletion requests directly to a data stream.
      # To delete a document in a data stream, you must target the backing index containing the document.
      # **Optimistic concurrency control**
      # Delete operations can be made conditional and only be performed if the last modification to the document was assigned the sequence number and primary term specified by the +if_seq_no+ and +if_primary_term+ parameters.
      # If a mismatch is detected, the operation will result in a +VersionConflictException+ and a status code of +409+.
      # **Versioning**
      # Each document indexed is versioned.
      # When deleting a document, the version can be specified to make sure the relevant document you are trying to delete is actually being deleted and it has not changed in the meantime.
      # Every write operation run on a document, deletes included, causes its version to be incremented.
      # The version number of a deleted document remains available for a short time after deletion to allow for control of concurrent operations.
      # The length of time for which a deleted document's version remains available is determined by the +index.gc_deletes+ index setting.
      # **Routing**
      # If routing is used during indexing, the routing value also needs to be specified to delete a document.
      # If the +_routing+ mapping is set to +required+ and no routing value is specified, the delete API throws a +RoutingMissingException+ and rejects the request.
      # For example:
      # +
      # DELETE /my-index-000001/_doc/1?routing=shard-1
      # +
      # This request deletes the document with ID 1, but it is routed based on the user.
      # The document is not deleted if the correct routing is not specified.
      # **Distributed**
      # The delete operation gets hashed into a specific shard ID.
      # It then gets redirected into the primary shard within that ID group and replicated (if needed) to shard replicas within that ID group.
      #
      # @option arguments [String] :id A unique identifier for the document. (*Required*)
      # @option arguments [String] :index The name of the target index. (*Required*)
      # @option arguments [Integer] :if_primary_term Only perform the operation if the document has this primary term.
      # @option arguments [Integer] :if_seq_no Only perform the operation if the document has this sequence number.
      # @option arguments [String] :refresh If +true+, Elasticsearch refreshes the affected shards to make this operation visible to search.
      #  If +wait_for+, it waits for a refresh to make this operation visible to search.
      #  If +false+, it does nothing with refreshes. Server default: false.
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Time] :timeout The period to wait for active shards.This parameter is useful for situations where the primary shard assigned to perform the delete operation might not be available when the delete operation runs.
      #  Some reasons for this might be that the primary shard is currently recovering from a store or undergoing relocation.
      #  By default, the delete operation will wait on the primary shard to become available for up to 1 minute before failing and responding with an error. Server default: 1m.
      # @option arguments [Integer] :version An explicit version number for concurrency control.
      #  It must match the current version of the document for the request to succeed.
      # @option arguments [String] :version_type The version type.
      # @option arguments [Integer, String] :wait_for_active_shards The minimum number of shard copies that must be active before proceeding with the operation.
      #  You can set it to +all+ or any positive integer up to the total number of shards in the index (+number_of_replicas+1+).
      #  The default value of +1+ means it waits for each primary shard to be active. Server default: 1.
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete
      #
      def delete(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'delete' }

        defined_params = [:index, :id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = nil

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_DELETE
        path   = "#{Utils.listify(_index)}/_doc/#{Utils.listify(_id)}"
        params = Utils.process_params(arguments)

        if Array(arguments[:ignore]).include?(404)
          Utils.rescue_from_not_found do
            Elasticsearch::API::Response.new(
              perform_request(method, path, params, body, headers, request_opts)
            )
          end
        else
          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
