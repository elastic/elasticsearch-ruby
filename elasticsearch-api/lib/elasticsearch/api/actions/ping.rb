module Elasticsearch
  module API
    module Actions

      # Returns true if the cluster returns a sucessfull HTTP response, false otherwise.
      #
      # @example
      #
      #     client.ping
      #
      # @see http://elasticsearch.org/guide/
      #
      def ping(arguments={})
        Utils.__rescue_from_not_found do
          ping_request_for(arguments).status == 200
        end
      end

      def ping_request_for(arguments={})
        method = HTTP_HEAD
        path   = ""
        params = {}
        body   = nil

        perform_request(method, path, params, body)
      end
    end
  end
end
