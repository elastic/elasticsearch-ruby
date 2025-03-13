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
      # Explain a document match result.
      # Get information about why a specific document matches, or doesn't match, a query.
      # It computes a score explanation for a query and a specific document.
      #
      # @option arguments [String] :id The document identifier. (*Required*)
      # @option arguments [String] :index Index names that are used to limit the request.
      #  Only a single index name can be provided to this parameter. (*Required*)
      # @option arguments [String] :analyzer The analyzer to use for the query string.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [Boolean] :analyze_wildcard If +true+, wildcard and prefix queries are analyzed.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [String] :default_operator The default operator for query string query: +AND+ or +OR+.
      #  This parameter can be used only when the +q+ query string parameter is specified. Server default: OR.
      # @option arguments [String] :df The field to use as default where no field prefix is given in the query string.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [Boolean] :lenient If +true+, format-based query failures (such as providing text to a numeric field) in the query string will be ignored.
      #  This parameter can be used only when the +q+ query string parameter is specified.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  It is random by default.
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Boolean, String, Array<String>] :_source +True+ or +false+ to return the +_source+ field or not or a list of fields to return.
      # @option arguments [String, Array<String>] :_source_excludes A comma-separated list of source fields to exclude from the response.
      #  You can also use this parameter to exclude fields from the subset specified in +_source_includes+ query parameter.
      #  If the +_source+ parameter is +false+, this parameter is ignored.
      # @option arguments [String, Array<String>] :_source_includes A comma-separated list of source fields to include in the response.
      #  If this parameter is specified, only these source fields are returned.
      #  You can exclude fields from this subset using the +_source_excludes+ query parameter.
      #  If the +_source+ parameter is +false+, this parameter is ignored.
      # @option arguments [String, Array<String>] :stored_fields A comma-separated list of stored fields to return in the response.
      # @option arguments [String] :q The query in the Lucene query string syntax.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-explain
      #
      def explain(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'explain' }

        defined_params = [:index, :id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = "#{Utils.listify(_index)}/_explain/#{Utils.listify(_id)}"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
