module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :id The ID of the index to check rollup capabilities on, or left blank for all jobs
          #
          # @see
          #
          def get_rollup_caps(arguments={})
            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/rollup/data/#{arguments[:id]}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
