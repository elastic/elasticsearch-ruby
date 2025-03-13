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
        # Clone an index.
        # Clone an existing index into a new index.
        # Each original primary shard is cloned into a new primary shard in the new index.
        # IMPORTANT: Elasticsearch does not apply index templates to the resulting index.
        # The API also does not copy index metadata from the original index.
        # Index metadata includes aliases, index lifecycle management phase definitions, and cross-cluster replication (CCR) follower information.
        # For example, if you clone a CCR follower index, the resulting clone will not be a follower index.
        # The clone API copies most index settings from the source index to the resulting index, with the exception of +index.number_of_replicas+ and +index.auto_expand_replicas+.
        # To set the number of replicas in the resulting index, configure these settings in the clone request.
        # Cloning works as follows:
        # * First, it creates a new target index with the same definition as the source index.
        # * Then it hard-links segments from the source index into the target index. If the file system does not support hard-linking, all segments are copied into the new index, which is a much more time consuming process.
        # * Finally, it recovers the target index as though it were a closed index which had just been re-opened.
        # IMPORTANT: Indices can only be cloned if they meet the following requirements:
        # * The index must be marked as read-only and have a cluster health status of green.
        # * The target index must not exist.
        # * The source index must have the same number of primary shards as the target index.
        # * The node handling the clone process must have sufficient free disk space to accommodate a second copy of the existing index.
        # The current write index on a data stream cannot be cloned.
        # In order to clone the current write index, the data stream must first be rolled over so that a new write index is created and then the previous write index can be cloned.
        # NOTE: Mappings cannot be specified in the +_clone+ request. The mappings of the source index will be used for the target index.
        # **Monitor the cloning process**
        # The cloning process can be monitored with the cat recovery API or the cluster health API can be used to wait until all primary shards have been allocated by setting the +wait_for_status+ parameter to +yellow+.
        # The +_clone+ API returns as soon as the target index has been added to the cluster state, before any shards have been allocated.
        # At this point, all shards are in the state unassigned.
        # If, for any reason, the target index can't be allocated, its primary shard will remain unassigned until it can be allocated on that node.
        # Once the primary shard is allocated, it moves to state initializing, and the clone process begins.
        # When the clone operation completes, the shard will become active.
        # At that point, Elasticsearch will try to allocate any replicas and may decide to relocate the primary shard to another node.
        # **Wait for active shards**
        # Because the clone operation creates a new index to clone the shards to, the wait for active shards setting on index creation applies to the clone index action as well.
        #
        # @option arguments [String] :index Name of the source index to clone. (*Required*)
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-clone
        #
        def clone(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.clone' }

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
          path   = "#{Utils.listify(_index)}/_clone/#{Utils.listify(_target)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
