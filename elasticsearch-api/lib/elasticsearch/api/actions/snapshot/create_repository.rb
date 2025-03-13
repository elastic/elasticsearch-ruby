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
    module Snapshot
      module Actions
        # Create or update a snapshot repository.
        # IMPORTANT: If you are migrating searchable snapshots, the repository name must be identical in the source and destination clusters.
        # To register a snapshot repository, the cluster's global metadata must be writeable.
        # Ensure there are no cluster blocks (for example, +cluster.blocks.read_only+ and +clsuter.blocks.read_only_allow_delete+ settings) that prevent write access.
        # Several options for this API can be specified using a query parameter or a request body parameter.
        # If both parameters are specified, only the query parameter is used.
        #
        # @option arguments [String] :repository The name of the snapshot repository to register or update. (*Required*)
        # @option arguments [Time] :master_timeout The period to wait for the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Time] :timeout The period to wait for a response from all relevant nodes in the cluster after updating the cluster metadata.
        #  If no response is received before the timeout expires, the cluster metadata update still applies but the response will indicate that it was not completely acknowledged.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Boolean] :verify If +true+, the request verifies the repository is functional on all master and data nodes in the cluster.
        #  If +false+, this verification is skipped.
        #  You can also perform this verification with the verify snapshot repository API. Server default: true.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body repository
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-create-repository
        #
        def create_repository(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.create_repository' }

          defined_params = [:repository].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _repository = arguments.delete(:repository)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_snapshot/#{Utils.listify(_repository)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
