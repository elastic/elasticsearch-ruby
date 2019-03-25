module Elasticsearch
  module API
    module Actions

      # The value of requests_per_second can be changed on a running update by query using the _rethrottle API
      #
      # @option arguments [String] :task_id The task id to rethrottle (*Required*)
      # @option arguments [Number] :requests_per_second The throttle to set on this request in floating sub-requests per second. -1 means set no throttle.
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-update-by-query.html
      #
      def update_by_query_rethrottle(arguments={})
        raise ArgumentError, "Required argument 'task_id' missing" unless arguments[:task_id]
        method = Elasticsearch::API::HTTP_POST
        path   = "_update_by_query/#{arguments[:task_id]}/_rethrottle"
        params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = nil

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:update_by_query_rethrottle, [
          :requests_per_second ].freeze)
    end
  end
end
