module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          def delete_expired_data(arguments={})
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/ml/_delete_expired_data"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
