module Elasticsearch
  module Client
    module Transport

      class Error < StandardError; end
      class ServerError < StandardError; end
      class SnifferTimeoutError < Timeout::Error; end

    end
  end
end
