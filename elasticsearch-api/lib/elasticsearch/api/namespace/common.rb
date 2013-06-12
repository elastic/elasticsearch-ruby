module Elasticsearch
  module API
    module Common

      module Client
        attr_reader :client

        def initialize(client)
          @client = client
        end

        def perform_request(method, path, params={}, body=nil)
          client.perform_request method, path, params, body
        end
      end

    end
  end
end
