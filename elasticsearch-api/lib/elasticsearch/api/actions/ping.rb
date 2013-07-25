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
        method = 'HEAD'
        path   = ""
        params = {}
        body   = nil

        perform_request(method, path, params, body).status == 200 ? true : false
        rescue Exception => e
          if e.class.to_s =~ /NotFound/ || e.message =~ /Not\s*Found|404/i
            false
          else
            raise e
          end
      end
    end
  end
end
