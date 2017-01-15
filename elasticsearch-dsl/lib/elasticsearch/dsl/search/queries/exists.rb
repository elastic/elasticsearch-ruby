module Elasticsearch
  module DSL
    module Search
      module Queries

        # Returns documents that have at least one non-null value in the field.
        #
        # @example Find documents with non-empty "name" property
        #
        #     search do
        #       query do
        #         exists do
        #           field 'name'
        #         end
        #       end
        #     end
        #
        # @note The "Exists" query can be used as a "Missing" query in a "Bool" query "Must Not" context.
        #
        # @example Find documents with an empty "name" property
        #
        #     search do
        #       query do
        #         bool do
        #           must_not do
        #             exists do
        #               field 'name'
        #             end
        #           end
        #         end
        #       end
        #     end
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/5.1/query-dsl-exists-query.html
        #
        class Exists
          include BaseComponent

          option_method :field
        end
      end
    end
  end
end
