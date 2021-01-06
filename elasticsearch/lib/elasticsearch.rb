# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require "elasticsearch/version"

require 'elasticsearch/transport'
require 'elasticsearch/api'

module Elasticsearch
  module Transport
    class Client
      include Elasticsearch::API

      # Constant for elasticsearch-transport meta-header
      META_HEADER_SERVICE_VERSION = [:es, Elasticsearch::VERSION]
    end
  end
end
