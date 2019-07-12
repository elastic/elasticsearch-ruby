# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Security
        module Actions

          # Get user privileges
          #
          def get_user_privileges(arguments={})
            method = Elasticsearch::API::HTTP_GET
            params = {}
            body   = nil

            perform_request(method, '_security/user/_privileges', params, body).body
          end
        end
      end
    end
  end
end
