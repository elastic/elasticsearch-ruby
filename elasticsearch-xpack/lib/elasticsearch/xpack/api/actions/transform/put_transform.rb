# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Transform
        module Actions
          # Instantiates a transform.
          #
          # @option arguments [String] :transform_id The id of the new transform.
          # @option arguments [Boolean] :defer_validation If validations should be deferred until transform starts, defaults to false.
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The transform definition (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/put-transform.html
          #
          def put_transform(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _transform_id = arguments.delete(:transform_id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_transform/#{Elasticsearch::API::Utils.__listify(_transform_id)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:put_transform, [
            :defer_validation
          ].freeze)
      end
    end
    end
  end
end
