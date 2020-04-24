# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
          @body = body.force_encoding('UTF-8') if body.respond_to?(:force_encoding)
        end
      end

    end
  end
end
