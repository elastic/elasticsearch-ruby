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
      # Check a document.
      # Verify that a document exists.
      # For example, check to see if a document with the +_id+ 0 exists:
      # +
      # HEAD my-index-000001/_doc/0
      # +
      # If the document exists, the API returns a status code of +200 - OK+.
      # If the document doesn’t exist, the API returns +404 - Not Found+.
      # **Versioning support**
      # You can use the +version+ parameter to check the document only if its current version is equal to the specified one.
      # Internally, Elasticsearch has marked the old document as deleted and added an entirely new document.
      # The old version of the document doesn't disappear immediately, although you won't be able to access it.
      # Elasticsearch cleans up deleted documents in the background as you continue to index more data.
      #
      # @option arguments [String] :id A unique document identifier. (*Required*)
      # @option arguments [String] :index A comma-separated list of data streams, indices, and aliases.
      #  It supports wildcards (+*+). (*Required*)
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
      # @option arguments [Integer] :version Explicit version number for concurrency control.
      #  The specified version must match the current version of the document for the request to succeed.
      # @option arguments [String] :version_type The version type.
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get
      #
      def exists(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'exists' }

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

        method = Elasticsearch::API::HTTP_HEAD
        path   = "#{Utils.listify(_index)}/_doc/#{Utils.listify(_id)}"
        params = Utils.process_params(arguments)

        Utils.rescue_from_not_found do
          perform_request(method, path, params, body, headers, request_opts).status == 200
        end
      end

      alias exists? exists
    end
  end
end
