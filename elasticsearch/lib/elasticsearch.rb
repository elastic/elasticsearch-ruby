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
    end
  end
end
module Elastic
  # If the version is X.X.X.pre/alpha/beta, use X.X.Xp for the meta-header:
  def self.client_meta_version
    regexp = /^([0-9]+\.[0-9]+\.[0-9]+)\.?([a-z0-9.-]+)?$/
    match = Elasticsearch::VERSION.match(regexp)
    return "#{match[1]}p" if match[2]

    Elasticsearch::VERSION
  end

  # Constant for elasticsearch-transport meta-header
  META_HEADER_SERVICE_VERSION = [:es, client_meta_version].freeze
end
