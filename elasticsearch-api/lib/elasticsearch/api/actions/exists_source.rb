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
      # Check for a document source.
      # Check whether a document source exists in an index.
      # For example:
      # +
      # HEAD my-index-000001/_source/1
      # +
      # A document's source is not available if it is disabled in the mapping.
      #
      # @option arguments [String] :id A unique identifier for the document. (*Required*)
      # @option arguments [String] :index A comma-separated list of data streams, indices, and aliases.
      #  It supports wildcards (+*+). (*Required*)
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  By default, the operation is randomized between the shard replicas.
      # @option arguments [Boolean] :realtime If +true+, the request is real-time as opposed to near-real-time. Server default: true.
      # @option arguments [Boolean] :refresh If +true+, the request refreshes the relevant shards before retrieving the document.
      #  Setting it to +true+ should be done after careful thought and verification that this does not cause a heavy load on the system (and slow down indexing).
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Boolean, String, Array<String>] :_source Indicates whether to return the +_source+ field (+true+ or +false+) or lists the fields to return.
      # @option arguments [String, Array<String>] :_source_excludes A comma-separated list of source fields to exclude in the response.
      # @option arguments [String, Array<String>] :_source_includes A comma-separated list of source fields to include in the response.
      # @option arguments [Integer] :version The version number for concurrency control.
      #  It must match the current version of the document for the request to succeed.
      # @option arguments [String] :version_type The version type.
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get
      #
      def exists_source(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'exists_source' }

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
        path   = "#{Utils.listify(_index)}/_source/#{Utils.listify(_id)}"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end

      alias exists_source? exists_source
    end
  end
end
