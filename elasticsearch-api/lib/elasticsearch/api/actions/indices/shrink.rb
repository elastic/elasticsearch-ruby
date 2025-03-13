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
        # Shrink an index.
        # Shrink an index into a new index with fewer primary shards.
        # Before you can shrink an index:
        # * The index must be read-only.
        # * A copy of every shard in the index must reside on the same node.
        # * The index must have a green health status.
        # To make shard allocation easier, we recommend you also remove the index's replica shards.
        # You can later re-add replica shards as part of the shrink operation.
        # The requested number of primary shards in the target index must be a factor of the number of shards in the source index.
        # For example an index with 8 primary shards can be shrunk into 4, 2 or 1 primary shards or an index with 15 primary shards can be shrunk into 5, 3 or 1.
        # If the number of shards in the index is a prime number it can only be shrunk into a single primary shard
        #  Before shrinking, a (primary or replica) copy of every shard in the index must be present on the same node.
        # The current write index on a data stream cannot be shrunk. In order to shrink the current write index, the data stream must first be rolled over so that a new write index is created and then the previous write index can be shrunk.
        # A shrink operation:
        # * Creates a new target index with the same definition as the source index, but with a smaller number of primary shards.
        # * Hard-links segments from the source index into the target index. If the file system does not support hard-linking, then all segments are copied into the new index, which is a much more time consuming process. Also if using multiple data paths, shards on different data paths require a full copy of segment files if they are not on the same disk since hardlinks do not work across disks.
        # * Recovers the target index as though it were a closed index which had just been re-opened. Recovers shards to the +.routing.allocation.initial_recovery._id+ index setting.
        # IMPORTANT: Indices can only be shrunk if they satisfy the following requirements:
        # * The target index must not exist.
        # * The source index must have more primary shards than the target index.
        # * The number of primary shards in the target index must be a factor of the number of primary shards in the source index. The source index must have more primary shards than the target index.
        # * The index must not contain more than 2,147,483,519 documents in total across all shards that will be shrunk into a single shard on the target index as this is the maximum number of docs that can fit into a single shard.
        # * The node handling the shrink process must have sufficient free disk space to accommodate a second copy of the existing index.
        #
        # @option arguments [String] :index Name of the source index to shrink. (*Required*)
        # @option arguments [String] :target Name of the target index to create. (*Required*)
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
        #  Set to +all+ or any positive integer up to the total number of shards in the index (+number_of_replicas+1+). Server default: 1.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-shrink
        #
        def shrink(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.shrink' }

          defined_params = [:index, :target].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          _target = arguments.delete(:target)

          method = Elasticsearch::API::HTTP_PUT
          path   = "#{Utils.listify(_index)}/_shrink/#{Utils.listify(_target)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
