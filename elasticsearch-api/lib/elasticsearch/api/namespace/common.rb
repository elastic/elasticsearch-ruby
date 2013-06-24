module Elasticsearch
  module API
    module Common
      module Actions; end

      # Base client wrapper
      #
      module Client
        attr_reader :client

        def initialize(client)
          @client = client
        end

        # Delegates the `perform_request` method to the wrapped client
        #
        def perform_request(method, path, params={}, body=nil)
          client.perform_request method, path, params, body
        end
      end

    end
  end
end
