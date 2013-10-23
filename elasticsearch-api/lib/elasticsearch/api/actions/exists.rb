module Elasticsearch
  module API
    module Actions

      # Return true if the specified document exists, false otherwise.
      #
      # @example
      #
      #     client.exists index: 'myindex', type: 'mytype', id: '1'
      #
      # @option arguments [String] :id The document ID (*Required*)
      # @option arguments [String] :index The name of the index (*Required*)
      # @option arguments [String] :type The type of the document (default: `_all`)
      # @option arguments [String] :parent The ID of the parent document
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on
      #                                        (default: random)
      # @option arguments [Boolean] :realtime Specify whether to perform the operation in realtime or search mode
      # @option arguments [Boolean] :refresh Refresh the shard containing the document before performing the operation
      # @option arguments [String] :routing Specific routing value
      #
      # @see http://elasticsearch.org/guide/reference/api/get/
      #
      def exists(arguments={})
        raise ArgumentError, "Required argument 'id' missing"    unless arguments[:id]
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        arguments[:type] ||= '_all'

        valid_params = [
          :parent,
          :preference,
          :realtime,
          :refresh,
          :routing ]

        method = 'HEAD'
        path   = Utils.__pathify Utils.__escape(arguments[:index]),
                                 Utils.__escape(arguments[:type]),
                                 Utils.__escape(arguments[:id])

        params = Utils.__validate_and_extract_params arguments, valid_params
        body   = nil

        perform_request(method, path, params, body).status == 200 ? true : false
        rescue Exception => e
          if e.class.to_s =~ /NotFound/ || e.message =~ /Not\s*Found|404/i
            false
          else
            raise e
          end
      end
    end
  end
end
