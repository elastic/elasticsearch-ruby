# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions

          # Updates an existing data frame transform.
          #
          # @option arguments [Hash] :transform_id The id of the new transform. *Required*
          # @option arguments [Hash] :body The update data frame transform definition. *Required*
          # @option arguments [Boolean] :defer_validation If validations should be deferred until data frame
          #   transform starts, defaults to false.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/update-data-frame-transform.html
          #
          # @since 7.4.0
          def update_data_frame_transform(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]
            arguments = arguments.clone

            transform_id = URI.escape(arguments.delete(:transform_id))
            body = arguments.delete(:body)

            method = Elasticsearch::API::HTTP_POST
            path   = "_data_frame/transforms/#{transform_id}/_update"
            params = Elasticsearch::API::Utils.__validate_and_extract_params(arguments, ParamsRegistry.get(__method__))

            perform_request(method, path, params, body).body
          end


          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:update_data_frame_transform, [ :defer_validation ].freeze)
        end
      end
    end
  end
end
