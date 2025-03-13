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
      # Get multiple documents.
      # Get multiple JSON documents by ID from one or more indices.
      # If you specify an index in the request URI, you only need to specify the document IDs in the request body.
      # To ensure fast responses, this multi get (mget) API responds with partial results if one or more shards fail.
      # **Filter source fields**
      # By default, the +_source+ field is returned for every document (if stored).
      # Use the +_source+ and +_source_include+ or +source_exclude+ attributes to filter what fields are returned for a particular document.
      # You can include the +_source+, +_source_includes+, and +_source_excludes+ query parameters in the request URI to specify the defaults to use when there are no per-document instructions.
      # **Get stored fields**
      # Use the +stored_fields+ attribute to specify the set of stored fields you want to retrieve.
      # Any requested fields that are not stored are ignored.
      # You can include the +stored_fields+ query parameter in the request URI to specify the defaults to use when there are no per-document instructions.
      #
      # @option arguments [String] :index Name of the index to retrieve documents from when +ids+ are specified, or when a document in the +docs+ array does not specify an index.
      # @option arguments [Boolean] :force_synthetic_source Should this request force synthetic _source?
      #  Use this to test if the mapping supports synthetic _source and to get a sense of the worst case performance.
      #  Fetches with this enabled will be slower the enabling synthetic source natively in the index.
      # @option arguments [String] :preference Specifies the node or shard the operation should be performed on. Random by default.
      # @option arguments [Boolean] :realtime If +true+, the request is real-time as opposed to near-real-time. Server default: true.
      # @option arguments [Boolean] :refresh If +true+, the request refreshes relevant shards before retrieving documents.
      # @option arguments [String] :routing Custom value used to route operations to a specific shard.
      # @option arguments [Boolean, String, Array<String>] :_source True or false to return the +_source+ field or not, or a list of fields to return.
      # @option arguments [String, Array<String>] :_source_excludes A comma-separated list of source fields to exclude from the response.
      #  You can also use this parameter to exclude fields from the subset specified in +_source_includes+ query parameter.
      # @option arguments [String, Array<String>] :_source_includes A comma-separated list of source fields to include in the response.
      #  If this parameter is specified, only these source fields are returned. You can exclude fields from this subset using the +_source_excludes+ query parameter.
      #  If the +_source+ parameter is +false+, this parameter is ignored.
      # @option arguments [String, Array<String>] :stored_fields If +true+, retrieves the document fields stored in the index rather than the document +_source+. Server default: false.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-mget
      #
      def mget(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'mget' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_POST
        path   = if _index
                   "#{Utils.listify(_index)}/_mget"
                 else
                   '_mget'
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
