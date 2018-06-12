module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # @option arguments [String] :filter_id The ID of the filter to fetch
          # @option arguments [Int] :from skips a number of filters
          # @option arguments [Int] :size specifies a max number of filters to get
          #
          def get_filters(arguments={})
            valid_params = [
              :from,
              :size ]
            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify "_xpack/ml/filters", arguments[:filter_id]
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
