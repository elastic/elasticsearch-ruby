# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module IndexLifecycleManagement
        module Actions
          # Removes the assigned lifecycle policy and stops managing the specified index
          #
          # @option arguments [String] :index The name of the index to remove policy on

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ilm-remove-policy.html
          #
          def remove_policy(arguments = {})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            arguments = arguments.clone

            _index = arguments.delete(:index)

            method = Elasticsearch::API::HTTP_POST
            path   = "#{Elasticsearch::API::Utils.__listify(_index)}/_ilm/remove"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
