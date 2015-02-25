module Elasticsearch
  module DSL
    module Search
      module Filters

        # A filter which executes another filter in the context of a nested document
        #
        # @example
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             nested do
        #               path 'comments'
        #               filter do
        #                 term 'comments.title' => 'Ruby'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see http://elasticsearch.org/guide/en/elasticsearch/reference/current/query-dsl-nested-filter.html
        #
        class Nested
          include BaseComponent

          option_method :path

          # DSL method for building the `filter` part of the query definition
          #
          # @return [self]
          #
          def filter(*args, &block)
            @filter = block ? Filter.new(*args, &block) : args.first
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
            hash
          end
        end

      end
    end
  end
end
