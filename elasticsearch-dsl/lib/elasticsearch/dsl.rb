# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'elasticsearch/dsl/version'

require 'elasticsearch/dsl/utils'
require 'elasticsearch/dsl/search/base_component'
require 'elasticsearch/dsl/search/base_compound_filter_component'
require 'elasticsearch/dsl/search/base_aggregation_component'
require 'elasticsearch/dsl/search/query'
require 'elasticsearch/dsl/search/collapse'
require 'elasticsearch/dsl/search/filter'
require 'elasticsearch/dsl/search/aggregation'
require 'elasticsearch/dsl/search/highlight'
require 'elasticsearch/dsl/search/inner_hits'
require 'elasticsearch/dsl/search/sort'
require 'elasticsearch/dsl/search/options'
require 'elasticsearch/dsl/search/suggest'

Dir[ File.expand_path('../dsl/search/queries/**/*.rb', __FILE__) ].each        { |f| require f }
Dir[ File.expand_path('../dsl/search/filters/**/*.rb', __FILE__) ].each        { |f| require f }
Dir[ File.expand_path('../dsl/search/aggregations/**/*.rb', __FILE__) ].each   { |f| require f }

require 'elasticsearch/dsl/search'

module Elasticsearch

  # The main module, which can be included into your own class or namespace,
  # to provide the DSL methods.
  #
  # @example
  #
  #     include Elasticsearch::DSL
  #
  #     definition = search do
  #       query do
  #         match title: 'test'
  #       end
  #     end
  #
  #     definition.to_hash
  #     # => { query: { match: { title: "test"} } }
  #
  # @see Search
  # @see https://www.elastic.co/guide/en/elasticsearch/guide/current/query-dsl-intro.html
  #
  module DSL
    def self.included(base)
      base.__send__ :include, Elasticsearch::DSL::Search
    end
  end
end
