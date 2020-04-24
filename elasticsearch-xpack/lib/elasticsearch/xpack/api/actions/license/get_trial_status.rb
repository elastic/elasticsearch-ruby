# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module License
        module Actions

          # TODO: Description
          #
          #
          # @see https://www.elastic.co/guide/en/x-pack/current/license-management.html
          #
          def get_trial_status(arguments={})
            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/license/trial_status"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
