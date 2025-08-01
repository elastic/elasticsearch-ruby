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
        # Open a closed index.
        # For data streams, the API opens any closed backing indices.
        # A closed index is blocked for read/write operations and does not allow all operations that opened indices allow.
        # It is not possible to index documents or to search for documents in a closed index.
        # This allows closed indices to not have to maintain internal data structures for indexing or searching documents, resulting in a smaller overhead on the cluster.
        # When opening or closing an index, the master is responsible for restarting the index shards to reflect the new state of the index.
        # The shards will then go through the normal recovery process.
        # The data of opened or closed indices is automatically replicated by the cluster to ensure that enough shard copies are safely kept around at all times.
        # You can open and close multiple indices.
        # An error is thrown if the request explicitly refers to a missing index.
        # This behavior can be turned off by using the `ignore_unavailable=true` parameter.
        # By default, you must explicitly name the indices you are opening or closing.
        # To open or close indices with `_all`, `*`, or other wildcard expressions, change the `action.destructive_requires_name` setting to `false`.
        # This setting can also be changed with the cluster update settings API.
        # Closed indices consume a significant amount of disk-space which can cause problems in managed environments.
        # Closing indices can be turned off with the cluster settings API by setting `cluster.indices.close.enable` to `false`.
        # Because opening or closing an index allocates its shards, the `wait_for_active_shards` setting on index creation applies to the `_open` and `_close` index actions as well.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases used to limit the request.
        #  Supports wildcards (`*`).
        #  By default, you must explicitly name the indices you using to limit the request.
        #  To limit a request using `_all`, `*`, or other wildcard expressions, change the `action.destructive_requires_name` setting to false.
        #  You can update this setting in the `elasticsearch.yml` file or using the cluster update settings API. (*Required*)
        # @option arguments [Boolean] :allow_no_indices If `false`, the request returns an error if any wildcard expression, index alias, or `_all` value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as `open,hidden`. Server default: open.
        # @option arguments [Boolean] :ignore_unavailable If `false`, the request returns an error if it targets a missing or closed index.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
        #  Set to `all` or any positive integer up to the total number of shards in the index (`number_of_replicas+1`). Server default: 1.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-open
        #
        def open(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.open' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.listify(_index)}/_open"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
