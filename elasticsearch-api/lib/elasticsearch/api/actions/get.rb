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
      # Get a document by its ID.
      # Get a document and its source or stored fields from an index.
      # By default, this API is realtime and is not affected by the refresh rate of the index (when data will become visible for search).
      # In the case where stored fields are requested with the +stored_fields+ parameter and the document has been updated but is not yet refreshed, the API will have to parse and analyze the source to extract the stored fields.
      # To turn off realtime behavior, set the +realtime+ parameter to false.
      # **Source filtering**
      # By default, the API returns the contents of the +_source+ field unless you have used the +stored_fields+ parameter or the +_source+ field is turned off.
      # You can turn off +_source+ retrieval by using the +_source+ parameter:
      # +
      # GET my-index-000001/_doc/0?_source=false
      # +
      # If you only need one or two fields from the +_source+, use the +_source_includes+ or +_source_excludes+ parameters to include or filter out particular fields.
      # This can be helpful with large documents where partial retrieval can save on network overhead
      # Both parameters take a comma separated list of fields or wildcard expressions.
      # For example:
      # +
      # GET my-index-000001/_doc/0?_source_includes=*.id&_source_excludes=entities
      # +
      # If you only want to specify includes, you can use a shorter notation:
      # +
      # GET my-index-000001/_doc/0?_source=*.id
      # +
      # **Routing**
      # If routing is used during indexing, the routing value also needs to be specified to retrieve a document.
      # For example:
      # +
      # GET my-index-000001/_doc/2?routing=user1
      # +
      # This request gets the document with ID 2, but it is routed based on the user.
      # The document is not fetched if the correct routing is not specified.
      # **Distributed**
      # The GET operation is hashed into a specific shard ID.
      # It is then redirected to one of the replicas within that shard ID and returns the result.
      # The replicas are the primary shard and its replicas within that shard ID group.
      # This means that the more replicas you have, the better your GET scaling will be.
      # **Versioning support**
      # You can use the +version+ parameter to retrieve the document only if its current version is equal to the specified one.
      # Internally, Elasticsearch has marked the old document as deleted and added an entirely new document.
      # The old version of the document doesn't disappear immediately, although you won't be able to access it.
      # Elasticsearch cleans up deleted documents in the background as you continue to index more data.
      #
      # @option arguments [String] :id A unique document identifier. (*Required*)
      # @option arguments [String] :index The name of the index that contains the document. (*Required*)
      # @option arguments [Boolean] :force_synthetic_source Indicates whether the request forces synthetic +_source+.
      #  Use this paramater to test if the mapping supports synthetic +_source+ and to get a sense of the worst case performance.
      #  Fetches with this parameter enabled will be slower than enabling synthetic source natively in the index.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  By default, the operation is randomized between the shard replicas.If it is set to +_local+, the operation will prefer to be run on a local allocated shard when possible.
      #  If it is set to a custom value, the value is used to guarantee that the same shards will be used for the same custom value.
      #  This can help with "jumping values" when hitting different shards in different refresh states.
      #  A sample value can be something like the web session ID or the user name.
      # @option arguments [Boolean] :realtime If +true+, the request is real-time as opposed to near-real-time. Server default: true.
      # @option arguments [Boolean] :refresh If +true+, the request refreshes the relevant shards before retrieving the document.
      #  Setting it to +true+ should be done after careful thought and verification that this does not cause a heavy load on the system (and slow down indexing).
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Boolean, String, Array<String>] :_source Indicates whether to return the +_source+ field (+true+ or +false+) or lists the fields to return.
      # @option arguments [String, Array<String>] :_source_excludes A comma-separated list of source fields to exclude from the response.
      #  You can also use this parameter to exclude fields from the subset specified in +_source_includes+ query parameter.
      #  If the +_source+ parameter is +false+, this parameter is ignored.
      # @option arguments [String, Array<String>] :_source_includes A comma-separated list of source fields to include in the response.
      #  If this parameter is specified, only these source fields are returned.
      #  You can exclude fields from this subset using the +_source_excludes+ query parameter.
      #  If the +_source+ parameter is +false+, this parameter is ignored.
      # @option arguments [String, Array<String>] :stored_fields A comma-separated list of stored fields to return as part of a hit.
      #  If no fields are specified, no stored fields are included in the response.
      #  If this field is specified, the +_source+ parameter defaults to +false+.
      #  Only leaf fields can be retrieved with the +stored_field+ option.
      #  Object fields can't be returned;​if specified, the request fails.
      # @option arguments [Integer] :version The version number for concurrency control.
      #  It must match the current version of the document for the request to succeed.
      # @option arguments [String] :version_type The version type.
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get
      #
      def get(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'get' }

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

        method = Elasticsearch::API::HTTP_GET
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
