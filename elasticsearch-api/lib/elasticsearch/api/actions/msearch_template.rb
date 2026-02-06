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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Actions
      # Run multiple templated searches.
      # Run multiple templated searches with a single request.
      # If you are providing a text file or text input to `curl`, use the `--data-binary` flag instead of `-d` to preserve newlines.
      # For example:
      #
      # ```
      # $ cat requests
      # { "index": "my-index" }
      # { "id": "my-search-template", "params": { "query_string": "hello world", "from": 0, "size": 10 }}
      # { "index": "my-other-index" }
      # { "id": "my-other-search-template", "params": { "query_type": "match_all" }}
      # $ curl -H "Content-Type: application/x-ndjson" -XGET localhost:9200/_msearch/template --data-binary "@requests"; echo
      # ```
      #
      # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases to search.
      #  It supports wildcards (`*`).
      #  To search all data streams and indices, omit this parameter or use `*`.
      # @option arguments [Boolean] :ccs_minimize_roundtrips If `true`, network round-trips are minimized for cross-cluster search requests. Server default: true.
      # @option arguments [Integer] :max_concurrent_searches The maximum number of concurrent searches the API can run.
      # @option arguments [String] :project_routing Specifies a subset of projects to target for the search using project
      #  metadata tags in a subset of Lucene query syntax.
      #  Allowed Lucene queries: the _alias tag and a single value (possibly wildcarded).
      #  Examples:
      #   _alias:my-project
      #   _alias:_origin
      #   _alias:*pr*
      #  Supported in serverless only.
      # @option arguments [String] :search_type The type of the search operation.
      # @option arguments [Boolean] :rest_total_hits_as_int If `true`, the response returns `hits.total` as an integer.
      #  If `false`, it returns `hits.total` as an object.
      # @option arguments [Boolean] :typed_keys If `true`, the response prefixes aggregation and suggester names with their respective types.
      # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
      #  when they occur.
      # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
      #  returned by Elasticsearch.
      # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
      #  For example `"exists_time": "1h"` for humans and
      #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
      #  readable values will be omitted. This makes sense for responses being consumed
      #  only by machines.
      # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
      #  this option for debugging only.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body search_templates
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-msearch-template
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

        Utils.update_ndjson_headers!(headers, transport.options.dig(:transport_options, :headers))
        Elasticsearch::API::Response.new(
          perform_request(method, path, params, payload, headers, request_opts)
        )
      end
    end
  end
end
