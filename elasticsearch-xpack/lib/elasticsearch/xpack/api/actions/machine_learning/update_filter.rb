module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Updates the description of a filter, adds items, or removes items.
          #
          # @option arguments [String] :filter_id The ID of the filter to update (*Required*)
          # @option arguments [Hash] :body The filter update (*Required*)
          #
          def update_filter(arguments={})
            raise ArgumentError, "Required argument 'filter_id' missing" unless arguments[:filter_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_POST
            path = "_xpack/ml/filters/#{arguments[:filter_id]}/_update"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
