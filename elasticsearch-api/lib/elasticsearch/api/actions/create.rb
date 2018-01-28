module Elasticsearch
  module API
    module Actions

      # Create a new document.
      #
      # The API will create new document, if it doesn't exist yet -- in that case, it will return
      # a `409` error (`version_conflict_engine_exception`).
      #
      # You can leave out the `:id` parameter for the ID to be generated automatically
      #
      # @example Create a document with an ID
      #
      #     client.create index: 'myindex',
      #                  type: 'doc',
      #                  id: '1',
      #                  body: {
      #                   title: 'Test 1'
      #                 }
      #
      # @example Create a document with an auto-generated ID
      #
      #     client.create index: 'myindex',
      #                  type: 'doc',
      #                  body: {
      #                   title: 'Test 1'
      #                 }
      #
      # @option (see Actions#index)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html#_automatic_id_generation
      #
      def create(arguments={})
        if arguments[:id]
          index arguments.update :op_type => 'create'
        else
          index arguments
        end
      end
    end
  end
end
