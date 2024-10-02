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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Snapshot
      module Actions
        # Analyzes a repository for correctness and performance
        #
        # @option arguments [String] :repository A repository name
        # @option arguments [Number] :blob_count Number of blobs to create during the test. Defaults to 100.
        # @option arguments [Number] :concurrency Number of operations to run concurrently during the test. Defaults to 10.
        # @option arguments [Number] :read_node_count Number of nodes on which to read a blob after writing. Defaults to 10.
        # @option arguments [Number] :early_read_node_count Number of nodes on which to perform an early read on a blob, i.e. before writing has completed. Early reads are rare actions so the 'rare_action_probability' parameter is also relevant. Defaults to 2.
        # @option arguments [Number] :seed Seed for the random number generator used to create the test workload. Defaults to a random value.
        # @option arguments [Number] :rare_action_probability Probability of taking a rare action such as an early read or an overwrite. Defaults to 0.02.
        # @option arguments [String] :max_blob_size Maximum size of a blob to create during the test, e.g '1gb' or '100mb'. Defaults to '10mb'.
        # @option arguments [String] :max_total_data_size Maximum total size of all blobs to create during the test, e.g '1tb' or '100gb'. Defaults to '1gb'.
        # @option arguments [Time] :timeout Explicit operation timeout. Defaults to '30s'.
        # @option arguments [Boolean] :detailed Whether to return detailed results or a summary. Defaults to 'false' so that only the summary is returned.
        # @option arguments [Boolean] :rarely_abort_writes Whether to rarely abort writes before they complete. Defaults to 'true'.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/modules-snapshots.html
        #
        def repository_analyze(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'snapshot.repository_analyze' }

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
          path   = "_snapshot/#{Utils.__listify(_repository)}/_analyze"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
