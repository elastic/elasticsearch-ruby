require "elasticsearch/version"

require 'elasticsearch/client'
require 'elasticsearch/api'

module Elasticsearch
  module Client
    class Client
      include Elasticsearch::API
    end
  end
end
