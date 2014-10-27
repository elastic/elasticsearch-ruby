module Elasticsearch
  module DSL
    module Search

      def search(*args, &block)
        Search.new(*args, &block)
      end

      class Search
        def initialize(*args, &block)
          instance_eval(&block) if block
        end

        def query(*args, &block)
          if block
            @query = Query.new(*args, &block)
          else
            @query = args.first
          end
          self
        end

        def to_hash
          hash = {}
          hash.update(query: @query.to_hash) if @query
          hash
        end
      end
    end
  end
end
