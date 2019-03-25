module Elasticsearch
  module API
    module Actions

      # The Painless execute API allows an arbitrary script to be executed and a result to be returned.
      #
      # @option arguments [Hash] :body The script to execute
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-execute-api.html
      #
      def scripts_painless_execute(arguments={})
        method = Elasticsearch::API::HTTP_GET
        path   = "_scripts/painless/_execute"
        params = {}
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:scripts_painless_execute, [
           ].freeze)
    end
  end
end
