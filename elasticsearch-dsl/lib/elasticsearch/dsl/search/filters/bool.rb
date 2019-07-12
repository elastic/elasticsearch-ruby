# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module DSL
    module Search
      module Filters

        # A compound filter which matches documents based on combinations of filters
        #
        # @example Defining a bool filter with multiple conditions
        #
        #     search do
        #       query do
        #         filtered do
        #           filter do
        #             bool do
        #               must do
        #                 term category: 'men'
        #               end
        #
        #               must do
        #                 term size:  'xxl'
        #               end
        #
        #               should do
        #                 term color: 'red'
        #               end
        #
        #               must_not do
        #                 term manufacturer: 'evil'
        #               end
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # See the integration test for a working example.
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-bool-filter.html
        #
        class Bool
          include BaseComponent

          def must(*args, &block)
            @hash[name][:must] ||= []
            value = args.empty? ? Filter.new(*args, &block).to_hash : args.first.to_hash
            @hash[name][:must].push(value).flatten! unless @hash[name][:must].include?(value)
            self
          end

          def must_not(*args, &block)
            @hash[name][:must_not] ||= []
            value = args.empty? ? Filter.new(*args, &block).to_hash : args.first.to_hash
            @hash[name][:must_not].push(value).flatten! unless @hash[name][:must_not].include?(value)
            self
          end

          def should(*args, &block)
            @hash[name][:should] ||= []
            value = args.empty? ? Filter.new(*args, &block).to_hash : args.first.to_hash
            @hash[name][:should].push(value).flatten! unless @hash[name][:should].include?(value)
            self
          end

          def to_hash
            @hash[name].update(@args.to_hash) if @args.respond_to?(:to_hash)

            if @block
              call
            else
              @hash[name] = @args unless @args.nil? || @args.empty?
            end

            @hash
          end
        end

      end
    end
  end
end
