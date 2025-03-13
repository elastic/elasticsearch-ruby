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
      # Count search results.
      # Get the number of documents matching a query.
      # The query can be provided either by using a simple query string as a parameter, or by defining Query DSL within the request body.
      # The query is optional. When no query is provided, the API uses +match_all+ to count all the documents.
      # The count API supports multi-target syntax. You can run a single count API search across multiple data streams and indices.
      # The operation is broadcast across all shards.
      # For each shard ID group, a replica is chosen and the search is run against it.
      # This means that replicas increase the scalability of the count.
      #
      # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases to search.
      #  It supports wildcards (+*+).
      #  To search all data streams and indices, omit this parameter or use +*+ or +_all+.
      # @option arguments [Boolean] :allow_no_indices If +false+, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
      #  This behavior applies even if the request targets other open indices.
      #  For example, a request targeting +foo*,bar*+ returns an error if an index starts with +foo+ but no index starts with +bar+. Server default: true.
      # @option arguments [String] :analyzer The analyzer to use for the query string.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [Boolean] :analyze_wildcard If +true+, wildcard and prefix queries are analyzed.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [String] :default_operator The default operator for query string query: +AND+ or +OR+.
      #  This parameter can be used only when the +q+ query string parameter is specified. Server default: OR.
      # @option arguments [String] :df The field to use as a default when no field prefix is given in the query string.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
      #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
      #  It supports comma-separated values, such as +open,hidden+. Server default: open.
      # @option arguments [Boolean] :ignore_throttled If +true+, concrete, expanded, or aliased indices are ignored when frozen. Server default: true.
      # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
      # @option arguments [Boolean] :lenient If +true+, format-based query failures (such as providing text to a numeric field) in the query string will be ignored.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [Float] :min_score The minimum +_score+ value that documents must have to be included in the result.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  By default, it is random.
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Integer] :terminate_after The maximum number of documents to collect for each shard.
      #  If a query reaches this limit, Elasticsearch terminates the query early.
      #  Elasticsearch collects documents before sorting.IMPORTANT: Use with caution.
      #  Elasticsearch applies this parameter to each shard handling the request.
      #  When possible, let Elasticsearch perform early termination automatically.
      #  Avoid specifying this parameter for requests that target data streams with backing indices across multiple data tiers.
      # @option arguments [String] :q The query in Lucene query string syntax. This parameter cannot be used with a request body.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-count
      #
      def count(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'count' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = if _index
                   "#{Utils.listify(_index)}/_count"
                 else
                   '_count'
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
