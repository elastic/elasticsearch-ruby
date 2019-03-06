module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :index The index or index-pattern (containing rollup or regular data) that should be searched (*Required*)
          # @option arguments [String] :type The doc type inside the index
          # @option arguments [Hash] :body The search request body (*Required*)
          #
          # @see
          #
          def rollup_search(arguments={})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

            valid_params = [ :typed_keys ]

            method = Elasticsearch::API::HTTP_GET
            path   = "#{arguments[:index]}/_rollup_search"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
