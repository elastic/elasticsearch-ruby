# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions

          # Deletes an existing data frame transform.
          #
          # @option arguments [String] :transform_id The id of the transform to delete. *Required*
          # @option arguments [Boolean] :force When `true`, the transform is deleted regardless of its current state.
          #   The default value is `false`, meaning that the transform must be `stopped` before it can be deleted.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/delete-data-frame-transform.html
          #
          # @since 7.2.0
          def delete_data_frame_transform(arguments={})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]
            arguments = arguments.clone
            transform_id = URI.escape(arguments.delete(:transform_id))

            valid_params = [
                :force]

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_data_frame/transforms/#{transform_id}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params(arguments, valid_params)
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
