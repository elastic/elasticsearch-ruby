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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Cat
      module Actions
        # Returns cluster-wide thread pool statistics per node.
        # By default the active, queue and rejected statistics are returned for all thread pools.
        #
        # @option arguments [List] :thread_pool_patterns A comma-separated list of regular-expressions to filter the thread pools in the output
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/cat-thread-pool.html
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
                     "_cat/thread_pool/#{Utils.__listify(_thread_pool_patterns)}"
                   else
                     '_cat/thread_pool'
                   end
          params = Utils.process_params(arguments)
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
