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
      # Run a search with a search template.
      #
      # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases to search.
      #  It supports wildcards (`*`).
      # @option arguments [Boolean] :allow_no_indices If `false`, the request returns an error if any wildcard expression, index alias, or `_all` value targets only missing or closed indices.
      #  This behavior applies even if the request targets other open indices.
      #  For example, a request targeting `foo*,bar*` returns an error if an index starts with `foo` but no index starts with `bar`. Server default: true.
      # @option arguments [Boolean] :ccs_minimize_roundtrips If `true`, network round-trips are minimized for cross-cluster search requests.
      # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
      #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
      #  Supports comma-separated values, such as `open,hidden`. Server default: open.
      # @option arguments [Boolean] :explain If `true`, the response includes additional details about score computation as part of a hit.
      # @option arguments [Boolean] :ignore_throttled If `true`, specified concrete, expanded, or aliased indices are not included in the response when throttled. Server default: true.
      # @option arguments [Boolean] :ignore_unavailable If `false`, the request returns an error if it targets a missing or closed index.
      # @option arguments [String] :preference The node or shard the operation should be performed on.
      #  It is random by default.
      # @option arguments [Boolean] :profile If `true`, the query execution is profiled.
      # @option arguments [String] :project_routing Specifies a subset of projects to target for the search using project
      #  metadata tags in a subset of Lucene query syntax.
      #  Allowed Lucene queries: the _alias tag and a single value (possibly wildcarded).
      #  Examples:
      #   _alias:my-project
      #   _alias:_origin
      #   _alias:*pr*
      #  Supported in serverless only.
      # @option arguments [String, Array<String>] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Time] :scroll Specifies how long a consistent view of the index
      #  should be maintained for scrolled search.
      # @option arguments [String] :search_type The type of the search operation.
      # @option arguments [Boolean] :rest_total_hits_as_int If `true`, `hits.total` is rendered as an integer in the response.
      #  If `false`, it is rendered as an object.
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
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search-template
      #
      def search_template(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'search_template' }

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
                   "#{Utils.listify(_index)}/_search/template"
                 else
                   '_search/template'
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
