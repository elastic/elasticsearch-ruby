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
        # Restore a snapshot.
        # Restore a snapshot of a cluster or data streams and indices.
        # You can restore a snapshot only to a running cluster with an elected master node.
        # The snapshot repository must be registered and available to the cluster.
        # The snapshot and cluster versions must be compatible.
        # To restore a snapshot, the cluster's global metadata must be writable. Ensure there are't any cluster blocks that prevent writes. The restore operation ignores index blocks.
        # Before you restore a data stream, ensure the cluster contains a matching index template with data streams enabled. To check, use the index management feature in Kibana or the get index template API:
        # +
        # GET _index_template/*?filter_path=index_templates.name,index_templates.index_template.index_patterns,index_templates.index_template.data_stream
        # +
        # If no such template exists, you can create one or restore a cluster state that contains one. Without a matching index template, a data stream can't roll over or create backing indices.
        # If your snapshot contains data from App Search or Workplace Search, you must restore the Enterprise Search encryption key before you restore the snapshot.
        #
        # @option arguments [String] :repository The name of the repository to restore a snapshot from. (*Required*)
        # @option arguments [String] :snapshot The name of the snapshot to restore. (*Required*)
        # @option arguments [Time] :master_timeout The period to wait for the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Boolean] :wait_for_completion If +true+, the request returns a response when the restore operation completes.
        #  The operation is complete when it finishes all attempts to recover primary shards for restored indices.
        #  This applies even if one or more of the recovery attempts fail.If +false+, the request returns a response when the restore operation initializes.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-restore
        #
        def restore(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.restore' }

          defined_params = [:repository, :snapshot].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'repository' missing" unless arguments[:repository]
          raise ArgumentError, "Required argument 'snapshot' missing" unless arguments[:snapshot]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _repository = arguments.delete(:repository)

          _snapshot = arguments.delete(:snapshot)

          method = Elasticsearch::API::HTTP_POST
          path   = "_snapshot/#{Utils.listify(_repository)}/#{Utils.listify(_snapshot)}/_restore"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
