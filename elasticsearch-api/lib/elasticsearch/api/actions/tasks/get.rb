module Elasticsearch
  module API
    module Tasks
      module Actions

        # Return information about a specific task
        #
        # @option arguments [String] :task_id Return the task with specified id (node_id:task_number) (*Required*)
        # @option arguments [Boolean] :wait_for_completion Wait for the matching tasks to complete (default: false)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/tasks.html
        #
        def get(arguments={})
          arguments = arguments.clone
          task_id = arguments.delete(:task_id)
          method = HTTP_GET
          path   = Utils.__pathify '_tasks', Utils.__escape(task_id)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get, [
            :wait_for_completion,
            :timeout ].freeze)
      end
    end
  end
end
