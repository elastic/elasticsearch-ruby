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
        method = HTTP_HEAD
        path   = ""
        params = {}
        body   = nil

        Utils.__rescue_from_not_found do
          perform_request(method, path, params, body).status == 200 ? true : false
        end
      end
    end
  end
end
