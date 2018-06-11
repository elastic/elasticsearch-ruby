module Elasticsearch
  module XPack
    module API
      module License
        module Actions

          # Get a license
          #
          # @option arguments [Boolean] :local Return local information (default: false)
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/license-management.html
          #
          def get(arguments={})
            valid_params = [ :local ]
            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/license"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
