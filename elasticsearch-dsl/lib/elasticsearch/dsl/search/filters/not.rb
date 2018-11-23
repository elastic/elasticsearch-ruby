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

        # A filter which takes out documents matching a filter from the results
        #
        # @note Since `not` is a keyword in Ruby, use the `_not` method in DSL definitions
        #
        # @example Pass the filter as a Hash
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             _not term: { color: 'red' }
        #           end
        #         end
        #       end
        #     end
        #
        # @example Define the filter with a block
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             _not do
        #               term color: 'red'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-not-filter.html
        #
        class Not
          include BaseComponent

          # Looks up the corresponding class for a method being invoked, and initializes it
          #
          # @raise [NoMethodError] When the corresponding class cannot be found
          #
          def method_missing(name, *args, &block)
            klass = Utils.__camelize(name)
            if Filters.const_defined? klass
              @value = Filters.const_get(klass).new(*args, &block)
            else
              raise NoMethodError, "undefined method '#{name}' for #{self}"
            end
          end

          # Convert the component to a Hash
          #
          # A default implementation, DSL classes can overload it.
          #
          # @return [Hash]
          #
          def to_hash(options={})
            case
            when (! @value || @value.empty?) && ! @block
              @hash = super
            when @block
              call
              @hash = { name.to_sym => @value.to_hash }
            end
            @hash
          end
        end
      end
    end
  end
end
