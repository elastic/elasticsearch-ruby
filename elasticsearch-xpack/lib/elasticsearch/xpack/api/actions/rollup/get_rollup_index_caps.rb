module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :index The rollup index or index pattern to obtain rollup capabilities from (*Required*)
          #
          # @see
          #
          def get_rollup_index_caps(arguments={})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
            method = Elasticsearch::API::HTTP_GET
            path   = "#{arguments[:index]}/_xpack/rollup/data"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
