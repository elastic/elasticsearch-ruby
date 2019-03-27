module Elasticsearch
  module API
    module Tasks
      module Actions

        # Return the list of tasks
        #
        # @option arguments [List] :nodes A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [List] :actions A comma-separated list of actions that should be returned. Leave empty to return all.
        # @option arguments [Boolean] :detailed Return detailed task information (default: false)
        # @option arguments [String] :parent_task_id Return tasks with specified parent task id (node_id:task_number). Set to -1 to return all.
        # @option arguments [Boolean] :wait_for_completion Wait for the matching tasks to complete (default: false)
        # @option arguments [String] :group_by Group tasks by nodes or parent/child relationships (options: nodes, parents, none)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/tasks.html
        #
        def list(arguments={})
          arguments = arguments.clone
          task_id = arguments.delete(:task_id)

          method = 'GET'
          path   = Utils.__pathify( '_tasks', Utils.__escape(task_id) )
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:list, [
            :nodes,
            :actions,
            :detailed,
            :parent_task_id,
            :wait_for_completion,
            :group_by,
            :timeout ].freeze)
      end
    end
  end
end
