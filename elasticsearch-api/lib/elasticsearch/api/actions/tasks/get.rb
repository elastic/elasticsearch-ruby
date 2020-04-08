# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Tasks
      module Actions
        # Returns information about a task.
        #
        # @option arguments [String] :task_id Return the task with specified id (node_id:task_number)
        # @option arguments [Boolean] :wait_for_completion Wait for the matching tasks to complete (default: false)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/tasks.html
        #
        def get(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _task_id = arguments.delete(:task_id)

          method = Elasticsearch::API::HTTP_GET
          path   = "_tasks/#{Utils.__listify(_task_id)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get, [
          :wait_for_completion,
          :timeout
        ].freeze)
end
      end
  end
end
