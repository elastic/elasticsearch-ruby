# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
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

        # A filter which executes a custom filter only for documents in specified indices,
        # and optionally another filter for documents in other indices
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             indices do
        #               indices ['audio', 'video']
        #
        #               filter do
        #                 terms tags: ['music']
        #               end
        #
        #               no_match_filter do
        #                 terms tags: ['music', 'audio', 'video']
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-indices-filter.html
        #
        class Indices
          include BaseComponent

          option_method :indices

          # DSL method for building the `filter` part of the query definition
          #
          # @return [self]
          #
          def filter(*args, &block)
            @filter = block ? Filter.new(*args, &block) : args.first
            self
          end

          # DSL method for building the `no_match_filter` part of the query definition
          #
          # @return [self]
          #
          def no_match_filter(*args, &block)
            @no_match_filter = block ? Filter.new(*args, &block) : args.first
            self
          end

          # Converts the query definition to a Hash
          #
          # @return [Hash]
          #
          def to_hash
            hash = super
            if @filter
              _filter = @filter.respond_to?(:to_hash) ? @filter.to_hash : @filter
              hash[self.name].update(filter: _filter)
            end
            if @no_match_filter
              _no_match_filter = @no_match_filter.respond_to?(:to_hash) ? @no_match_filter.to_hash : @no_match_filter
              hash[self.name].update(no_match_filter: _no_match_filter)
            end
            hash
          end
        end

      end
    end
  end
end
