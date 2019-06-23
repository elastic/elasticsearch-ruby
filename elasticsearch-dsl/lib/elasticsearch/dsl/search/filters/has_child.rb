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

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which returns parent documents for children documents matching a query or a filter
        #
        # @example Return articles where John has commented
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             has_child do
        #               type 'comment'
        #               query do
        #                 match author: 'John'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-has-child-filter.html
        #
        class HasChild
          include BaseComponent

          option_method :type
          option_method :min_children
          option_method :max_children
          option_method :inner_hits

          # DSL method for building the `query` part of the query definition
          #
          # @return [self]
          #
          def query(*args, &block)
            @query = block ? Elasticsearch::DSL::Search::Query.new(*args, &block) : args.first
            self
          end

          # DSL method for building the `filter` part of the query definition
          #
          # @return [self]
          #
          def filter(*args, &block)
            @filter = block ? Elasticsearch::DSL::Search::Filter.new(*args, &block) : args.first
            self
          end

          # Converts the query definition to a Hash
          #
          # @return [Hash]
          #
          def to_hash
            hash = super
            if @query
              _query = @query.respond_to?(:to_hash) ? @query.to_hash : @query
              hash[self.name].update(query: _query)
            end
            if @filter
              _filter = @filter.respond_to?(:to_hash) ? @filter.to_hash : @filter
              hash[self.name].update(filter: _filter)
            end
            hash
          end
        end

      end
    end
  end
end
