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
    module IndexLifecycleManagement
      module Actions
        # Retrieves information about the index's current lifecycle state, such as the currently executing phase, action, and step.
        #
        # @option arguments [String] :index The name of the index to explain
        # @option arguments [Boolean] :only_managed filters the indices included in the response to ones managed by ILM
        # @option arguments [Boolean] :only_errors filters the indices included in the response to ones in an ILM error state, implies only_managed
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/ilm-explain-lifecycle.html
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

          body   = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = "#{Utils.__listify(_index)}/_ilm/explain"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
