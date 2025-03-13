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
    module CrossClusterReplication
      module Actions
        # Create a follower.
        # Create a cross-cluster replication follower index that follows a specific leader index.
        # When the API returns, the follower index exists and cross-cluster replication starts replicating operations from the leader index to the follower index.
        #
        # @option arguments [String] :index The name of the follower index. (*Required*)
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [Integer, String] :wait_for_active_shards Specifies the number of shards to wait on being active before responding. This defaults to waiting on none of the shards to be
        #  active.
        #  A shard must be restored from the leader index before being active. Restoring a follower shard requires transferring all the
        #  remote Lucene segment files to the follower index.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ccr-follow
        #
        def follow(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ccr.follow' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_PUT
          path   = "#{Utils.listify(_index)}/_ccr/follow"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
