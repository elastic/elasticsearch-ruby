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
        # Move to a lifecycle step.
        # Manually move an index into a specific step in the lifecycle policy and run that step.
        # WARNING: This operation can result in the loss of data. Manually moving an index into a specific step runs that step even if it has already been performed. This is a potentially destructive action and this should be considered an expert level API.
        # You must specify both the current step and the step to be executed in the body of the request.
        # The request will fail if the current step does not match the step currently running for the index
        # This is to prevent the index from being moved from an unexpected step into the next step.
        # When specifying the target (+next_step+) to which the index will be moved, either the name or both the action and name fields are optional.
        # If only the phase is specified, the index will move to the first step of the first action in the target phase.
        # If the phase and action are specified, the index will move to the first step of the specified action in the specified phase.
        # Only actions specified in the ILM policy are considered valid.
        # An index cannot move to a step that is not part of its policy.
        #
        # @option arguments [String] :index The name of the index whose lifecycle step is to change (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ilm-move-to-step
        #
        def move_to_step(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ilm.move_to_step' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ilm/move/#{Utils.listify(_index)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
