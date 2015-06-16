module Elasticsearch
  module API
    module Actions

      # Return simple information about the cluster (name, version).
      #
      # @see http://elasticsearch.org/guide/
      #
      def info(arguments={})
        info_request_for(arguments).body
      end

      def info_request_for(arguments={})
        method = HTTP_GET
        path   = ""
        params = {}
        body   = nil

        perform_request(method, path, params, body)
      end
    end
  end
end
