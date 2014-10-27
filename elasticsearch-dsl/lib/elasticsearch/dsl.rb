require 'elasticsearch/dsl/version'

require 'elasticsearch/dsl/search/base_component'

module Elasticsearch
  module DSL
    def self.included(base)
      base.__send__ :include, Elasticsearch::DSL::Search
    end
  end
end
