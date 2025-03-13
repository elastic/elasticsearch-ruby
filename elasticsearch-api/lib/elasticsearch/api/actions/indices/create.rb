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
        # Create an index.
        # You can use the create index API to add a new index to an Elasticsearch cluster.
        # When creating an index, you can specify the following:
        # * Settings for the index.
        # * Mappings for fields in the index.
        # * Index aliases
        # **Wait for active shards**
        # By default, index creation will only return a response to the client when the primary copies of each shard have been started, or the request times out.
        # The index creation response will indicate what happened.
        # For example, +acknowledged+ indicates whether the index was successfully created in the cluster, +while shards_acknowledged+ indicates whether the requisite number of shard copies were started for each shard in the index before timing out.
        # Note that it is still possible for either +acknowledged+ or +shards_acknowledged+ to be +false+, but for the index creation to be successful.
        # These values simply indicate whether the operation completed before the timeout.
        # If +acknowledged+ is false, the request timed out before the cluster state was updated with the newly created index, but it probably will be created sometime soon.
        # If +shards_acknowledged+ is false, then the request timed out before the requisite number of shards were started (by default just the primaries), even if the cluster state was successfully updated to reflect the newly created index (that is to say, +acknowledged+ is +true+).
        # You can change the default of only waiting for the primary shards to start through the index setting +index.write.wait_for_active_shards+.
        # Note that changing this setting will also affect the +wait_for_active_shards+ value on all subsequent write operations.
        #
        # @option arguments [String] :index Name of the index you wish to create. (*Required*)
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
        #  Set to +all+ or any positive integer up to the total number of shards in the index (+number_of_replicas+1+). Server default: 1.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-create
        #
        def create(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.create' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_PUT
          path   = Utils.listify(_index).to_s
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
