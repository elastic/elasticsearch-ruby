require 'elasticsearch/dsl/version'


module Elasticsearch
  module DSL
    def self.included(base)
      base.__send__ :include, Elasticsearch::DSL::Search
    end
  end
end
