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
        # Get the snapshot status.
        # Get a detailed description of the current state for each shard participating in the snapshot.
        # Note that this API should be used only to obtain detailed shard-level information for ongoing snapshots.
        # If this detail is not needed or you want to obtain information about one or more existing snapshots, use the get snapshot API.
        # If you omit the +<snapshot>+ request path parameter, the request retrieves information only for currently running snapshots.
        # This usage is preferred.
        # If needed, you can specify +<repository>+ and +<snapshot>+ to retrieve information for specific snapshots, even if they're not currently running.
        # WARNING: Using the API to return the status of any snapshots other than currently running snapshots can be expensive.
        # The API requires a read from the repository for each shard in each snapshot.
        # For example, if you have 100 snapshots with 1,000 shards each, an API request that includes all snapshots will require 100,000 reads (100 snapshots x 1,000 shards).
        # Depending on the latency of your storage, such requests can take an extremely long time to return results.
        # These requests can also tax machine resources and, when using cloud storage, incur high processing costs.
        #
        # @option arguments [String] :repository The snapshot repository name used to limit the request.
        #  It supports wildcards (+*+) if +<snapshot>+ isn't specified.
        # @option arguments [String, Array<String>] :snapshot A comma-separated list of snapshots to retrieve status for.
        #  The default is currently running snapshots.
        #  Wildcards (+*+) are not supported.
        # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error for any snapshots that are unavailable.
        #  If +true+, the request ignores snapshots that are unavailable, such as those that are corrupted or temporarily cannot be returned.
        # @option arguments [Time] :master_timeout The period to wait for the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-status
        #
        def status(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.status' }

          defined_params = [:repository, :snapshot].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          method = Elasticsearch::API::HTTP_GET
          path   = if _repository && _snapshot
                     "_snapshot/#{Utils.listify(_repository)}/#{Utils.listify(_snapshot)}/_status"
                   elsif _repository
                     "_snapshot/#{Utils.listify(_repository)}/_status"
                   else
                     '_snapshot/_status'
                   end
          params = Utils.process_params(arguments)

          if Array(arguments[:ignore]).include?(404)
            Utils.rescue_from_not_found do
              Elasticsearch::API::Response.new(
                perform_request(method, path, params, body, headers, request_opts)
              )
            end
          else
            Elasticsearch::API::Response.new(
              perform_request(method, path, params, body, headers, request_opts)
            )
          end
        end
      end
    end
  end
end
