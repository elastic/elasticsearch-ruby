# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Migration
        module Actions
          # Retrieves information about different cluster, node, and index level settings that use deprecated features that will be removed or changed in the next major version.
          #
          # @option arguments [String] :index Index pattern
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/migration-api-deprecation.html
          #
          def deprecations(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _index = arguments.delete(:index)

            method = Elasticsearch::API::HTTP_GET
            path   = if _index
                       "#{Elasticsearch::API::Utils.__listify(_index)}/_migration/deprecations"
                     else
                       "_migration/deprecations"
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
