# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module IndexLifecycleManagement
        module Actions
          # Returns the specified policy definition. Includes the policy version and last modified date.
          #
          # @option arguments [String] :policy The name of the index lifecycle policy
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/ilm-get-lifecycle.html
          #
          def get_lifecycle(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _policy = arguments.delete(:policy)

            method = Elasticsearch::API::HTTP_GET
            path   = if _policy
                       "_ilm/policy/#{Elasticsearch::API::Utils.__listify(_policy)}"
                     else
                       "_ilm/policy"
            end
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
