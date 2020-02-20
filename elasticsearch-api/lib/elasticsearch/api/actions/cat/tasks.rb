# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cat
      module Actions
        # Returns information about the tasks currently executing on one or more nodes in the cluster.
        #
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [List] :node_id A comma-separated list of node IDs or names to limit the returned information; use `_local` to return information from the node you're connecting to, leave empty to get information from all nodes
        # @option arguments [List] :actions A comma-separated list of actions that should be returned. Leave empty to return all.
        # @option arguments [Boolean] :detailed Return detailed task information (default: false)
        # @option arguments [Number] :parent_task Return tasks with specified parent task id. Set to -1 to return all.
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values
        #   (options: d (Days),h (Hours),m (Minutes),s (Seconds),ms (Milliseconds),micros (Microseconds),nanos (Nanoseconds))

        # @option arguments [Boolean] :v Verbose mode. Display column headers

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/tasks.html
        #
        def tasks(arguments = {})
          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_GET
          path   = "_cat/tasks"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:tasks, [
          :format,
          :node_id,
          :actions,
          :detailed,
          :parent_task,
          :h,
          :help,
          :s,
          :time,
          :v
        ].freeze)
end
      end
  end
end
