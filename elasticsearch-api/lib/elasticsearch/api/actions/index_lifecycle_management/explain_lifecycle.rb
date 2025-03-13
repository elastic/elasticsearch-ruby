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
    module IndexLifecycleManagement
      module Actions
        # Explain the lifecycle state.
        # Get the current lifecycle status for one or more indices.
        # For data streams, the API retrieves the current lifecycle status for the stream's backing indices.
        # The response indicates when the index entered each lifecycle state, provides the definition of the running phase, and information about any failures.
        #
        # @option arguments [String] :index Comma-separated list of data streams, indices, and aliases to target. Supports wildcards (+*+).
        #  To target all data streams and indices, use +*+ or +_all+. (*Required*)
        # @option arguments [Boolean] :only_errors Filters the returned indices to only indices that are managed by ILM and are in an error state, either due to an encountering an error while executing the policy, or attempting to use a policy that does not exist.
        # @option arguments [Boolean] :only_managed Filters the returned indices to only indices that are managed by ILM.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ilm-explain-lifecycle
        #
        def explain_lifecycle(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ilm.explain_lifecycle' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = "#{Utils.listify(_index)}/_ilm/explain"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
