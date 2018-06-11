module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # @option arguments [String] :filter_id The ID of the filter to create (*Required*)
          # @option arguments [Hash] :body The filter details (*Required*)
          #
          def put_filter(arguments={})
            raise ArgumentError, "Required argument 'filter_id' missing" unless arguments[:filter_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/ml/filters/#{arguments[:filter_id]}"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
