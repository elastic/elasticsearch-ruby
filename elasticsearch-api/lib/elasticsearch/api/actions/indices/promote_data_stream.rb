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
        # Promote a data stream.
        # Promote a data stream from a replicated data stream managed by cross-cluster replication (CCR) to a regular data stream.
        # With CCR auto following, a data stream from a remote cluster can be replicated to the local cluster.
        # These data streams can't be rolled over in the local cluster.
        # These replicated data streams roll over only if the upstream data stream rolls over.
        # In the event that the remote cluster is no longer available, the data stream in the local cluster can be promoted to a regular data stream, which allows these data streams to be rolled over in the local cluster.
        # NOTE: When promoting a data stream, ensure the local cluster has a data stream enabled index template that matches the data stream.
        # If this is missing, the data stream will not be able to roll over until a matching index template is created.
        # This will affect the lifecycle management of the data stream and interfere with the data stream size and retention.
        #
        # @option arguments [String] :name The name of the data stream (*Required*)
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-promote-data-stream
        #
        def promote_data_stream(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.promote_data_stream' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_POST
          path   = "_data_stream/_promote/#{Utils.listify(_name)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
