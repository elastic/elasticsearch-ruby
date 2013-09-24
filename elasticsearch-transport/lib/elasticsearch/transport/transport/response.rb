module Elasticsearch
  module Transport
    module Transport

      # Wraps the response from Elasticsearch.
      #
      class Response
        attr_reader :status, :body, :headers

        # @param status  [Integer] Response status code
        # @param body    [String]  Response body
        # @param headers [Hash]    Response headers
        def initialize(status, body, headers={})
          @status, @body, @headers = status, body, headers
        end
      end

    end
  end
end
