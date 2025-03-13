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
      # Get term vector information.
      # Get information and statistics about terms in the fields of a particular document.
      # You can retrieve term vectors for documents stored in the index or for artificial documents passed in the body of the request.
      # You can specify the fields you are interested in through the +fields+ parameter or by adding the fields to the request body.
      # For example:
      # +
      # GET /my-index-000001/_termvectors/1?fields=message
      # +
      # Fields can be specified using wildcards, similar to the multi match query.
      # Term vectors are real-time by default, not near real-time.
      # This can be changed by setting +realtime+ parameter to +false+.
      # You can request three types of values: _term information_, _term statistics_, and _field statistics_.
      # By default, all term information and field statistics are returned for all fields but term statistics are excluded.
      # **Term information**
      # * term frequency in the field (always returned)
      # * term positions (+positions: true+)
      # * start and end offsets (+offsets: true+)
      # * term payloads (+payloads: true+), as base64 encoded bytes
      # If the requested information wasn't stored in the index, it will be computed on the fly if possible.
      # Additionally, term vectors could be computed for documents not even existing in the index, but instead provided by the user.
      #
      # @option arguments [String] :index The name of the index that contains the document. (*Required*)
      # @option arguments [String] :id A unique identifier for the document.
      # @option arguments [String, Array<String>] :fields A comma-separated list or wildcard expressions of fields to include in the statistics.
      #  It is used as the default list unless a specific field list is provided in the +completion_fields+ or +fielddata_fields+ parameters.
      # @option arguments [Boolean] :field_statistics If +true+, the response includes:
      #  - The document count (how many documents contain this field).
      #  - The sum of document frequencies (the sum of document frequencies for all terms in this field).
      #  - The sum of total term frequencies (the sum of total term frequencies of each term in this field). Server default: true.
      # @option arguments [Boolean] :offsets If +true+, the response includes term offsets. Server default: true.
      # @option arguments [Boolean] :payloads If +true+, the response includes term payloads. Server default: true.
      # @option arguments [Boolean] :positions If +true+, the response includes term positions. Server default: true.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  It is random by default.
      # @option arguments [Boolean] :realtime If true, the request is real-time as opposed to near-real-time. Server default: true.
      # @option arguments [String] :routing A custom value that is used to route operations to a specific shard.
      # @option arguments [Boolean] :term_statistics If +true+, the response includes:
      #  - The total term frequency (how often a term occurs in all documents).
      #  - The document frequency (the number of documents containing the current term).
      #  By default these values are not returned since term statistics can have a serious performance impact.
      # @option arguments [Integer] :version If +true+, returns the document version as part of a hit.
      # @option arguments [String] :version_type The version type.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-termvectors
      #
      def termvectors(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'termvectors' }

        defined_params = [:index, :id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _index = arguments.delete(:index)

        _id = arguments.delete(:id)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        arguments.delete(:endpoint)
        path = if _index && _id
                 "#{Utils.listify(_index)}/_termvectors/#{Utils.listify(_id)}"
               else
                 "#{Utils.listify(_index)}/_termvectors"
               end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end

      # Deprecated: Use the plural version, {#termvectors}
      #
      def termvector(arguments = {})
        warn '[DEPRECATION] `termvector` is deprecated. Please use the plural version, `termvectors` instead.'
        termvectors(arguments.merge(endpoint: '_termvector'))
      end
    end
  end
end
