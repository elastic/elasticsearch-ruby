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
      # Run multiple templated searches.
      # Run multiple templated searches with a single request.
      # If you are providing a text file or text input to +curl+, use the +--data-binary+ flag instead of +-d+ to preserve newlines.
      # For example:
      # +
      # $ cat requests
      # { "index": "my-index" }
      # { "id": "my-search-template", "params": { "query_string": "hello world", "from": 0, "size": 10 }}
      # { "index": "my-other-index" }
      # { "id": "my-other-search-template", "params": { "query_type": "match_all" }}
      # $ curl -H "Content-Type: application/x-ndjson" -XGET localhost:9200/_msearch/template --data-binary "@requests"; echo
      # +
      #
      # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases to search.
      #  It supports wildcards (+*+).
      #  To search all data streams and indices, omit this parameter or use +*+.
      # @option arguments [Boolean] :ccs_minimize_roundtrips If +true+, network round-trips are minimized for cross-cluster search requests. Server default: true.
      # @option arguments [Integer] :max_concurrent_searches The maximum number of concurrent searches the API can run.
      # @option arguments [String] :search_type The type of the search operation.
      # @option arguments [Boolean] :rest_total_hits_as_int If +true+, the response returns +hits.total+ as an integer.
      #  If +false+, it returns +hits.total+ as an object.
      # @option arguments [Boolean] :typed_keys If +true+, the response prefixes aggregation and suggester names with their respective types.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body search_templates
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-msearch-template
      #
      def msearch_template(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'msearch_template' }

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
                   "#{Utils.listify(_index)}/_msearch/template"
                 else
                   '_msearch/template'
                 end
        params = Utils.process_params(arguments)

        if body.is_a?(Array)
          payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
          payload << '' unless payload.empty?
          payload = payload.join("\n")
        else
          payload = body
        end

        headers.merge!('Content-Type' => 'application/x-ndjson')
        Elasticsearch::API::Response.new(
          perform_request(method, path, params, payload, headers, request_opts)
        )
      end
    end
  end
end
