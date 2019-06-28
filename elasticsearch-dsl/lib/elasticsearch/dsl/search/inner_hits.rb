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

      # Wraps the `inner_hits` part of a search definition
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-inner-hits.html
      #
      class InnerHits
        include BaseComponent

        # Initialize the inner_hits definition.
        #
        # @param [ String, Symbol ] name The name to be used for the particular inner hit definition in the response.
        #   Useful when multiple inner hits have been defined in a single search request. The default depends in which
        #   query the inner hit is defined. For has_child query and filter this is the child type, has_parent query
        #   and filter this is the parent type and the nested query and filter this is the nested path.
        #
        # @since 0.1.9
        def initialize(name, &block)
          @value = { name: name }
          super
        end

        # Specify the size setting on the inner_hits definition, the maximum number of hits to return per inner_hits.
        #   By default the top three matching hits are returned.
        #
        # @example
        #   inner_hits 'last_tweet' do
        #     size 10
        #     from 5
        #   end
        #
        # @param [ Integer ] size The size setting.
        #
        # @return self.
        #
        # @since 0.1.9
        def size(size)
          @value[:size] = size
          self
        end

        # Specify the from setting on the inner_hits definition, the offset from where the first hit to fetch for
        #   each inner_hits in the returned regular search hits.
        #
        # @example
        #   inner_hits 'last_tweet' do
        #     size 10
        #     from 5
        #   end
        #
        # @param [ Integer ] from The from setting.
        #
        # @return self.
        #
        # @since 0.1.9
        def from(from)
          @value[:from] = from
          self
        end

        # Specify the sorting on the inner_hits definition. By default the hits are sorted by the score.
        #
        # @example
        #   inner_hits 'last_tweet' do
        #     size 10
        #     from 5
        #     sort do
        #       by :date, order: 'desc'
        #       by :likes, order: 'asc'
        #     end
        #   end
        #
        # @param [ Integer ] from The from setting.
        #
        # @return self.
        #
        # @since 0.1.9
        def sort(*args, &block)
          if !args.empty? || block
            @sort = Sort.new(*args, &block)
            self
          else
            @sort
          end
        end

        # Convert the definition to a hash, to be used in a search request.
        #
        # @example
        #   definition = begin do
        #     inner_hits 'last_tweet' do
        #       size 10
        #       from 5
        #       sort do
        #         by :date, order: 'desc'
        #         by :likes, order: 'asc'
        #       end
        #     end
        #
        # @return [ Hash ] The inner_hits clause as a hash.
        #
        # @since 0.1.9
        def to_hash
          call
          @hash = @value
          @hash[:sort] = @sort.to_hash if @sort
          @hash
        end
      end
    end
  end
end
