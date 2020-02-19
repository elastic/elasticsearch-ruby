# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # TODO: Description

          #
          # @see [TODO]
          #
          def delete_expired_data(arguments = {})
            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/_delete_expired_data"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
