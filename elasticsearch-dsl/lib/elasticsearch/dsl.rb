require 'elasticsearch/dsl/version'

require 'elasticsearch/dsl/search'
require 'elasticsearch/dsl/search/base_component'
require 'elasticsearch/dsl/search/query'

Dir[ File.expand_path('../dsl/search/queries/**/*.rb', __FILE__) ].each   { |f| require f }

module Elasticsearch
  module DSL
    def self.included(base)
      base.__send__ :include, Elasticsearch::DSL::Search
    end
  end
end
