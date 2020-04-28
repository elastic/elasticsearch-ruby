# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module IndexLifecycleManagement
        module Actions
          # Creates a lifecycle policy
          #
          # @option arguments [String] :policy The name of the index lifecycle policy
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The lifecycle policy definition to register
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/ilm-put-lifecycle.html
          #
          def put_lifecycle(arguments = {})
            raise ArgumentError, "Required argument 'policy' missing" unless arguments[:policy]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _policy = arguments.delete(:policy)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_ilm/policy/#{Elasticsearch::API::Utils.__listify(_policy)}"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
