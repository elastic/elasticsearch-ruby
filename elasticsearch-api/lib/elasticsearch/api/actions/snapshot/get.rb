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
        # Get snapshot information.
        # NOTE: The +after+ parameter and +next+ field enable you to iterate through snapshots with some consistency guarantees regarding concurrent creation or deletion of snapshots.
        # It is guaranteed that any snapshot that exists at the beginning of the iteration and is not concurrently deleted will be seen during the iteration.
        # Snapshots concurrently created may be seen during an iteration.
        #
        # @option arguments [String] :repository A comma-separated list of snapshot repository names used to limit the request.
        #  Wildcard (+*+) expressions are supported. (*Required*)
        # @option arguments [String, Array<String>] :snapshot A comma-separated list of snapshot names to retrieve
        #  Wildcards (+*+) are supported.
        #  - To get information about all snapshots in a registered repository, use a wildcard (+*+) or +_all+.
        #  - To get information about any snapshots that are currently running, use +_current+. (*Required*)
        # @option arguments [String] :after An offset identifier to start pagination from as returned by the next field in the response body.
        # @option arguments [String] :from_sort_value The value of the current sort column at which to start retrieval.
        #  It can be a string +snapshot-+ or a repository name when sorting by snapshot or repository name.
        #  It can be a millisecond time value or a number when sorting by +index-+ or shard count.
        # @option arguments [Boolean] :ignore_unavailable If +false+, the request returns an error for any snapshots that are unavailable.
        # @option arguments [Boolean] :index_details If +true+, the response includes additional information about each index in the snapshot comprising the number of shards in the index, the total size of the index in bytes, and the maximum number of segments per shard in the index.
        #  The default is +false+, meaning that this information is omitted.
        # @option arguments [Boolean] :index_names If +true+, the response includes the name of each index in each snapshot. Server default: true.
        # @option arguments [Boolean] :include_repository If +true+, the response includes the repository name in each snapshot. Server default: true.
        # @option arguments [Time] :master_timeout The period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [String] :order The sort order.
        #  Valid values are +asc+ for ascending and +desc+ for descending order.
        #  The default behavior is ascending order. Server default: asc.
        # @option arguments [Integer] :offset Numeric offset to start pagination from based on the snapshots matching this request. Using a non-zero value for this parameter is mutually exclusive with using the after parameter. Defaults to 0. Server default: 0.
        # @option arguments [Integer] :size The maximum number of snapshots to return.
        #  The default is 0, which means to return all that match the request without limit. Server default: 0.
        # @option arguments [String] :slm_policy_filter Filter snapshots by a comma-separated list of snapshot lifecycle management (SLM) policy names that snapshots belong to.You can use wildcards (+*+) and combinations of wildcards followed by exclude patterns starting with +-+.
        #  For example, the pattern +*,-policy-a-\*+ will return all snapshots except for those that were created by an SLM policy with a name starting with +policy-a-+.
        #  Note that the wildcard pattern +*+ matches all snapshots created by an SLM policy but not those snapshots that were not created by an SLM policy.
        #  To include snapshots that were not created by an SLM policy, you can use the special pattern +_none+ that will match all snapshots without an SLM policy.
        # @option arguments [String] :sort The sort order for the result.
        #  The default behavior is sorting by snapshot start time stamp. Server default: start_time.
        # @option arguments [Boolean] :verbose If +true+, returns additional information about each snapshot such as the version of Elasticsearch which took the snapshot, the start and end times of the snapshot, and the number of shards snapshotted.NOTE: The parameters +size+, +order+, +after+, +from_sort_value+, +offset+, +slm_policy_filter+, and +sort+ are not supported when you set +verbose=false+ and the sort order for requests with +verbose=false+ is undefined. Server default: true.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-get
        #
        def get(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.get' }

          defined_params = [:repository, :snapshot].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing" unless arguments[:snapshot]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          method = Elasticsearch::API::HTTP_GET
          path   = "_snapshot/#{Utils.listify(_repository)}/#{Utils.listify(_snapshot)}"
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
