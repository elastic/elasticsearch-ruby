# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Tasks
      module Actions
        # Cancels a task, if it can be cancelled through an API.
        #
        # @option arguments [String] :task_id Cancel the task with specified task id (node_id:task_number)
        # @option arguments [List] :nodes A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [List] :actions A comma-separated list of actions that should be cancelled. Leave empty to cancel all.
        # @option arguments [String] :parent_task_id Cancel tasks with specified parent task id (node_id:task_number). Set to -1 to cancel all.

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/tasks.html
        #
        def cancel(arguments = {})
          arguments = arguments.clone

          _task_id = arguments.delete(:task_id)

          method = HTTP_POST
          path   = if _task_id
                     "_tasks/#{Utils.__listify(_task_id)}/_cancel"
                   else
                     "_tasks/_cancel"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:cancel, [
          :nodes,
          :actions,
          :parent_task_id
        ].freeze)
end
      end
  end
end
