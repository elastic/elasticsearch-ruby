# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :id The ID of the job to stop
          # @option arguments [Boolean] :wait_for_completion True if the API should block until the job has fully stopped, false if should be executed async. Defaults to false.
          # @option arguments [Time] :timeout Block for (at maximum) the specified duration while waiting for the job to stop.  Defaults to 30s.

          #
          # @see
          #
          def stop_job(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_rollup/job/#{Elasticsearch::API::Utils.__listify(_id)}/_stop"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:stop_job, [
            :wait_for_completion,
            :timeout
          ].freeze)
      end
    end
    end
  end
end
