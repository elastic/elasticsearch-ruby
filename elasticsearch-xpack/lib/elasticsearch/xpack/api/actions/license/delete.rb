module Elasticsearch
  module XPack
    module API
      module License
        module Actions

          # Delete a license
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/license-management.html
          #
          def delete(arguments={})
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/license"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
