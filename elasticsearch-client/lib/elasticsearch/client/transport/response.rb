module Elasticsearch
  module Client
    module Transport

      class Response
        attr_reader :status, :body, :headers

        def initialize(status, body, headers={})
          @status, @body, @headers = status, body, headers
        end
      end

    end
  end
end
