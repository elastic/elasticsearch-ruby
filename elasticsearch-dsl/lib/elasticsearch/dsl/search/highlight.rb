module Elasticsearch
  module DSL
    module Search

      # Wraps the `highlight` part of a search definition
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-request-highlighting.html
      #
      class Highlight
        include BaseComponent

        def initialize(*args, &block)
          @value = args.pop || {}
          super
        end

        # Specify the fields to highlight
        #
        # @example
        #
        #     search do
        #       highlight do
        #         fields [:title, :body]
        #         field  :comments.body if options[:comments]
        #       end
        #     end
        #
        def fields(value_or_name)
          value = case value_or_name
            when Hash
              value_or_name
            when Array
              value_or_name.reduce({}) { |sum, item| sum.update item.to_sym => {}; sum }
            else
          end

          (@value[:fields] ||= {}).update value
          self
        end

        # Specify a single field to highlight
        #
        # @example
        #
        #     search do
        #       highlight do
        #         field :title, fragment_size: 0
        #         field :body if options[:comments]
        #       end
        #     end
        #
        def field(name, options={})
          (@value[:fields] ||= {}).update name.to_sym => options
        end

        # Specify the opening tags for the highlighted snippets
        #
        def pre_tags(*value)
          @value[:pre_tags] = value.flatten
        end; alias_method :pre_tags=, :pre_tags

        # Specify the closing tags for the highlighted snippets
        #
        def post_tags(*value)
          @value[:post_tags] = value.flatten
        end; alias_method :post_tags=, :post_tags

        # Specify the `encoder` option for highlighting
        #
        def encoder(value)
          @value[:encoder] = value
        end; alias_method :encoder=, :encoder

        # Specify the `tags_schema` option for highlighting
        #
        def tags_schema(value)
          @value[:tags_schema] = value
        end; alias_method :tags_schema=, :tags_schema

        # Convert the definition to a Hash
        #
        # @return [Hash]
        #
        def to_hash
          call
          @hash = @value
          @hash
        end
      end
    end
  end
end
