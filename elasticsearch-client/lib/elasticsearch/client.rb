require "time"
require "timeout"
require "multi_json"
require "faraday"

require "elasticsearch/client/transport/serializer/multi_json"
require "elasticsearch/client/transport/sniffer"
require "elasticsearch/client/transport/response"
require "elasticsearch/client/transport/errors"
require "elasticsearch/client/transport/base"
require "elasticsearch/client/transport/connections/selector"
require "elasticsearch/client/transport/connections/connection"
require "elasticsearch/client/transport/connections/collection"
require "elasticsearch/client/transport/http/faraday"
require "elasticsearch/client/client"

require "elasticsearch/client/version"

module Elasticsearch
  module Client

    # A convenience wrapper for {::Elasticsearch::Client::Client#initialize}.
    #
    def new(arguments={})
      Elasticsearch::Client::Client.new(arguments)
    end
    extend self
  end
end
