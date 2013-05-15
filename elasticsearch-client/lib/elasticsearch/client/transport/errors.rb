module Elasticsearch
  module Client
    module Transport

      # Generic client error
      #
      class Error < StandardError; end

      # Elasticsearch server error (HTTP status 5xx)
      #
      class ServerError < StandardError; end

      # Reloading connections timeout (1 sec by default)
      #
      class SnifferTimeoutError < Timeout::Error; end

    end
  end
end
