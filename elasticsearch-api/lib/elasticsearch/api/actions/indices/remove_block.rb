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
    module Indices
      module Actions
        # Remove an index block.
        # Remove an index block from an index.
        # Index blocks limit the operations allowed on an index by blocking specific operation types.
        #
        # @option arguments [String] :index A comma-separated list or wildcard expression of index names used to limit the request.
        #  By default, you must explicitly name the indices you are removing blocks from.
        #  To allow the removal of blocks from indices with `_all`, `*`, or other wildcard expressions, change the `action.destructive_requires_name` setting to `false`.
        #  You can update this setting in the `elasticsearch.yml` file or by using the cluster update settings API. (*Required*)
        # @option arguments [String] :block The block type to remove from the index. (*Required*)
        # @option arguments [Boolean] :allow_no_indices If `false`, the request returns an error if any wildcard expression, index alias, or `_all` value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices.
        #  For example, a request targeting `foo*,bar*` returns an error if an index starts with `foo` but no index starts with `bar`. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  It supports comma-separated values, such as `open,hidden`. Server default: open.
        # @option arguments [Boolean] :ignore_unavailable If `false`, the request returns an error if it targets a missing or closed index.
        # @option arguments [Time] :master_timeout The period to wait for the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  It can also be set to `-1` to indicate that the request should never timeout. Server default: 30s.
        # @option arguments [Time] :timeout The period to wait for a response from all relevant nodes in the cluster after updating the cluster metadata.
        #  If no response is received before the timeout expires, the cluster metadata update still applies but the response will indicate that it was not completely acknowledged.
        #  It can also be set to `-1` to indicate that the request should never timeout. Server default: 30s.
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
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-remove-block
        #
        def remove_block(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.remove_block' }

          defined_params = [:index, :block].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'block' missing" unless arguments[:block]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          _block = arguments.delete(:block)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "#{Utils.listify(_index)}/_block/#{Utils.listify(_block)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
