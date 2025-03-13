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
    module SearchableSnapshots
      module Actions
        # Mount a snapshot.
        # Mount a snapshot as a searchable snapshot index.
        # Do not use this API for snapshots managed by index lifecycle management (ILM).
        # Manually mounting ILM-managed snapshots can interfere with ILM processes.
        #
        # @option arguments [String] :repository The name of the repository containing the snapshot of the index to mount. (*Required*)
        # @option arguments [String] :snapshot The name of the snapshot of the index to mount. (*Required*)
        # @option arguments [Time] :master_timeout The period to wait for the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Boolean] :wait_for_completion If true, the request blocks until the operation is complete.
        # @option arguments [String] :storage The mount option for the searchable snapshot index. Server default: full_copy.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-searchable-snapshots-mount
        #
        def mount(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'searchable_snapshots.mount' }

          defined_params = [:repository, :snapshot].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing" unless arguments[:snapshot]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          method = Elasticsearch::API::HTTP_POST
          path   = "_snapshot/#{Utils.listify(_repository)}/#{Utils.listify(_snapshot)}/_mount"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
