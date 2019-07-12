# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Common
      module Actions; end

      module Client

        # Base client wrapper
        #
        module Base
          attr_reader :client

          def initialize(client)
            @client = client
          end
        end

        # Delegates the `perform_request` method to the wrapped client
        #
        def perform_request(method, path, params={}, body=nil, headers=nil)
          client.perform_request method, path, params, body, headers
        end
      end

    end
  end
end
