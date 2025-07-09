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
    module Cat
      module Actions
        # Get thread pool statistics.
        # Get thread pool statistics for each node in a cluster.
        # Returned information includes all built-in thread pools and custom thread pools.
        # IMPORTANT: cat APIs are only intended for human consumption using the command line or Kibana console. They are not intended for use by applications. For application consumption, use the nodes info API.
        #
        # @option arguments [String, Array<String>] :thread_pool_patterns A comma-separated list of thread pool names used to limit the request.
        #  Accepts wildcard expressions.
        # @option arguments [String, Array<String>] :h List of columns to appear in the response. Supports simple wildcards.
        # @option arguments [String, Array<String>] :s A comma-separated list of column names or aliases that determines the sort order.
        #  Sorting defaults to ascending and can be changed by setting `:asc`
        #  or `:desc` as a suffix to the column name.
        # @option arguments [String] :time The unit used to display time values.
        # @option arguments [Boolean] :local If `true`, the request computes the list of selected nodes from the
        #  local cluster state. If `false` the list of selected nodes are computed
        #  from the cluster state of the master node. In both cases the coordinating
        #  node will send requests for further information to each selected node.
        # @option arguments [Time] :master_timeout The period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  `text`, `json`, `cbor`, `yaml`, or `smile`. Server default: text.
        # @option arguments [Boolean] :help When set to `true` will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to `true` will enable verbose output.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-thread-pool
        #
        def thread_pool(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.thread_pool' }

          defined_params = [:thread_pool_patterns].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _thread_pool_patterns = arguments.delete(:thread_pool_patterns)

          method = Elasticsearch::API::HTTP_GET
          path   = if _thread_pool_patterns
                     "_cat/thread_pool/#{Utils.listify(_thread_pool_patterns)}"
                   else
                     '_cat/thread_pool'
                   end
          params = Utils.process_params(arguments)
          params[:h] = Utils.listify(params[:h]) if params[:h]

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
