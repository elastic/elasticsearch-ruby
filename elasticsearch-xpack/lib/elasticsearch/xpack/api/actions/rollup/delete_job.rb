# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :id The ID of the job to delete (*Required*)
          #
          # @see
          #
          def delete_job(arguments={})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/rollup/job/#{arguments[:id]}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
