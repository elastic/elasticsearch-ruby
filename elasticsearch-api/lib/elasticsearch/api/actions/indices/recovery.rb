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
        # Get index recovery information.
        # Get information about ongoing and completed shard recoveries for one or more indices.
        # For data streams, the API returns information for the stream's backing indices.
        # All recoveries, whether ongoing or complete, are kept in the cluster state and may be reported on at any time.
        # Shard recovery is the process of initializing a shard copy, such as restoring a primary shard from a snapshot or creating a replica shard from a primary shard.
        # When a shard recovery completes, the recovered shard is available for search and indexing.
        # Recovery automatically occurs during the following processes:
        # * When creating an index for the first time.
        # * When a node rejoins the cluster and starts up any missing primary shard copies using the data that it holds in its data path.
        # * Creation of new replica shard copies from the primary.
        # * Relocation of a shard copy to a different node in the same cluster.
        # * A snapshot restore operation.
        # * A clone, shrink, or split operation.
        # You can determine the cause of a shard recovery using the recovery or cat recovery APIs.
        # The index recovery API reports information about completed recoveries only for shard copies that currently exist in the cluster.
        # It only reports the last recovery for each shard copy and does not report historical information about earlier recoveries, nor does it report information about the recoveries of shard copies that no longer exist.
        # This means that if a shard copy completes a recovery and then Elasticsearch relocates it onto a different node then the information about the original recovery will not be shown in the recovery API.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases used to limit the request.
        #  Supports wildcards (+*+).
        #  To target all data streams and indices, omit this parameter or use +*+ or +_all+.
        # @option arguments [Boolean] :active_only If +true+, the response only includes ongoing shard recoveries.
        # @option arguments [Boolean] :detailed If +true+, the response includes detailed information about shard recoveries.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-recovery
        #
        def recovery(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.recovery' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "#{Utils.listify(_index)}/_recovery"
                   else
                     '_recovery'
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
