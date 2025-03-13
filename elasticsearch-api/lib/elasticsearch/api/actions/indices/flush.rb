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
    module Indices
      module Actions
        # Flush data streams or indices.
        # Flushing a data stream or index is the process of making sure that any data that is currently only stored in the transaction log is also permanently stored in the Lucene index.
        # When restarting, Elasticsearch replays any unflushed operations from the transaction log into the Lucene index to bring it back into the state that it was in before the restart.
        # Elasticsearch automatically triggers flushes as needed, using heuristics that trade off the size of the unflushed transaction log against the cost of performing each flush.
        # After each operation has been flushed it is permanently stored in the Lucene index.
        # This may mean that there is no need to maintain an additional copy of it in the transaction log.
        # The transaction log is made up of multiple files, called generations, and Elasticsearch will delete any generation files when they are no longer needed, freeing up disk space.
        # It is also possible to trigger a flush on one or more indices using the flush API, although it is rare for users to need to call this API directly.
        # If you call the flush API after indexing some documents then a successful response indicates that Elasticsearch has flushed all the documents that were indexed before the flush API was called.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases to flush.
        #  Supports wildcards (+*+).
        #  To flush all data streams and indices, omit this parameter or use +*+ or +_all+.
        # @option arguments [Boolean] :allow_no_indices If +false+, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as +open,hidden+.
        #  Valid values are: +all+, +open+, +closed+, +hidden+, +none+. Server default: open.
        # @option arguments [Boolean] :force If +true+, the request forces a flush even if there are no changes to commit to the index. Server default: true.
        # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error if it targets a missing or closed index.
        # @option arguments [Boolean] :wait_if_ongoing If +true+, the flush operation blocks until execution when another flush operation is running.
        #  If +false+, Elasticsearch returns an error if you request a flush when another flush operation is running. Server default: true.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-flush
        #
        def flush(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.flush' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _index
                     "#{Utils.listify(_index)}/_flush"
                   else
                     '_flush'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
