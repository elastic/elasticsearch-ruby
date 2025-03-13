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
        # Clean up the snapshot repository.
        # Trigger the review of the contents of a snapshot repository and delete any stale data not referenced by existing snapshots.
        #
        # @option arguments [String] :repository The name of the snapshot repository to clean up. (*Required*)
        # @option arguments [Time] :master_timeout The period to wait for a connection to the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+ Server default: 30s.
        # @option arguments [Time] :timeout The period to wait for a response from all relevant nodes in the cluster after updating the cluster metadata.
        #  If no response is received before the timeout expires, the cluster metadata update still applies but the response will indicate that it was not completely acknowledged.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-cleanup-repository
        #
        def cleanup_repository(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.cleanup_repository' }

          defined_params = [:repository].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _repository = arguments.delete(:repository)

          method = Elasticsearch::API::HTTP_POST
          path   = "_snapshot/#{Utils.listify(_repository)}/_cleanup"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
