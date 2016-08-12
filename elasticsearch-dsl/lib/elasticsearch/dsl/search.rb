module Elasticsearch
  module DSL

    # Provides DSL methods for building the search definition
    # (queries, filters, aggregations, sorting, etc)
    #
    module Search

      # Initialize a new Search object
      #
      # @example Building a search definition declaratively
      #
      #     definition = search do
      #       query do
      #         match title: 'test'
      #       end
      #     end
      #
      # @example Using the class imperatively
      #
      #     definition = Search.new
      #     query = Query.new
      #     definition.query query
      #     definition.to_hash
      #     # => => {:query=>{:match=>{:title=>"Test"}}}
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search.html
      #
      def search(*args, &block)
        Search.new(*args, &block)
      end

      extend self

      # Wraps the whole search definition (queries, filters, aggregations, sorting, etc)
      #
      class Search
        attr_reader :aggregations

        def initialize(*args, &block)
          @options = Options.new *args
          block.arity < 1 ? self.instance_eval(&block) : block.call(self) if block
        end

        # DSL method for building or accessing the `query` part of a search definition
        #
        # @return [self, {Query}]
        #
        def query(*args, &block)
          case
            when block
              @query = Query.new(*args, &block)
              self
            when !args.empty?
              @query = args.first
              self
            else
              @query
          end
        end

        # Set the query part of a search definition
        #
        def query=(value)
          query value
        end

        # DSL method for building the `filter` part of a search definition
        #
        # @return [self]
        #
        def filter(*args, &block)
          case
            when block
              @filter = Filter.new(*args, &block)
              self
            when !args.empty?
              @filter = args.first
              self
            else
              @filter
          end
        end

        # Set the filter part of a search definition
        #
        def filter=(value)
          filter value
        end

        # DSL method for building the `post_filter` part of a search definition
        #
        # @return [self]
        #
        def post_filter(*args, &block)
          case
            when block
              @post_filter = Filter.new(*args, &block)
              self
            when !args.empty?
              @post_filter = args.first
              self
            else
              @post_filter
          end
        end

        # Set the post_filter part of a search definition
        #
        def post_filter=(value)
          post_filter value
        end

        # DSL method for building the `aggregations` part of a search definition
        #
        # @return [self]
        #
        def aggregation(*args, &block)
          @aggregations ||= AggregationsCollection.new

          if block
            @aggregations.update args.first => Aggregation.new(*args, &block)
          else
            name = args.shift
            @aggregations.update name => args.shift
          end
          self
        end

        # Set the aggregations part of a search definition
        #
        def aggregations=(value)
          @aggregations = value
        end

        # DSL method for building the `highlight` part of a search definition
        #
        # @return [self]
        #
        def highlight(*args, &block)
          if !args.empty? || block
            @highlight = Highlight.new(*args, &block)
            self
          else
            @highlight
          end
        end

        # DSL method for building the `sort` part of a search definition
        #
        # @return [self]
        #
        def sort(*args, &block)
          if !args.empty? || block
            @sort = Sort.new(*args, &block)
            self
          else
            @sort
          end
        end

        # DSL method for building the `size` part of a search definition
        #
        # @return [self]
        #
        def size(value=nil)
          if value
            @size = value
            self
          else
            @size
          end
        end; alias_method :size=, :size

        # DSL method for building the `from` part of a search definition
        #
        # @return [self]
        #
        def from(value=nil)
          if value
            @from = value
            self
          else
            @from
          end
        end; alias_method :from=, :from

        # DSL method for building the `suggest` part of a search definition
        #
        # @return [self]
        #
        def suggest(*args, &block)
          if !args.empty? || block
            @suggest ||= {}
            key, options = args
            @suggest.update key => Suggest.new(key, options, &block)
            self
          else
            @suggest
          end
        end

        # Set the suggest part of a search definition
        #
        def suggest=(value)
          @suggest = value
        end

        # Delegates to the methods provided by the {Options} class
        #
        def method_missing(name, *args, &block)
          if @options.respond_to? name
            @options.__send__ name, *args, &block
            self
          else
            super
          end
        end

        # Converts the search definition to a Hash
        #
        # @return [Hash]
        #
        def to_hash
          hash = {}
          hash.update(query: @query.to_hash)   if @query
          hash.update(filter: @filter.to_hash) if @filter
          hash.update(post_filter: @post_filter.to_hash) if @post_filter
          hash.update(aggregations: @aggregations.reduce({}) { |sum,item| sum.update item.first => item.last.to_hash }) if @aggregations
          hash.update(sort: @sort.to_hash) if @sort
          hash.update(size: @size) if @size
          hash.update(from: @from) if @from
          hash.update(suggest: @suggest.reduce({}) { |sum,item| sum.update item.last.to_hash }) if @suggest
          hash.update(highlight: @highlight.to_hash) if @highlight
          hash.update(@options) unless @options.empty?
          hash
        end
      end
    end
  end
end
