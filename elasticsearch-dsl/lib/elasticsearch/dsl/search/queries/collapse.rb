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

      # Wraps the `collapse` part of a search definition
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-collapse.html
      #
      # @since 0.1.9
      class Collapse
        include BaseComponent

        # Initialize the field collapse definition.
        #
        # @param field [ String, Symbol ] The name of the field.
        #
        # @since 0.1.9
        def initialize(field, &block)
          @hash = { field: field }
          @block = block
        end

        # Create an inner_hits definition.
        #
        # @example
        #   collapse :user
        #     inner_hits 'last_tweet' do
        #       size 10
        #       from 5
        #       sort do
        #         by :date, order: 'desc'
        #         by :likes, order: 'asc'
        #       end
        #     end
        #   end
        #
        # @return self
        #
        # @since 0.1.9
        def inner_hits(name, &block)
          @inner_hits = InnerHits.new(name, &block)
          self
        end

        # Specify the max_concurrent_group_searches setting on the collapse definition.
        #
        # @example
        #   collapse :user
        #     max_concurrent_group_searches 4
        #   end
        #
        # @return self.
        #
        # @since 0.1.9
        def max_concurrent_group_searches(max)
          @hash[:max_concurrent_group_searches] = max
          self
        end

        # Convert the definition to a hash, to be used in a search request.
        #
        # @example
        #   definition = collapse :user
        #     max_concurrent_group_searches 4
        #   end
        #
        # @return [ Hash ] The collapse clause as a hash.
        #
        # @since 0.1.9
        def to_hash
          call
          @hash[:inner_hits] = @inner_hits.to_hash if @inner_hits
          @hash
        end
      end
    end
  end
end
