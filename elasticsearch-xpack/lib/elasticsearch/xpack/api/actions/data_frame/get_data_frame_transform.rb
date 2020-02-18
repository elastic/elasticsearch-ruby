# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions
          # Retrieves configuration information for data frame transforms.
          #
          # @option arguments [Integer] :transform_id The id or comma delimited list of id expressions of the
          #   transforms to get, '_all' or '*' implies get all transforms.
          # @option arguments [Integer] :from Skips a number of transform configs, defaults to 0
          # @option arguments [Integer] :size Specifies a max number of transforms to get, defaults to 100
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/get-data-frame-transform.html
          #
          # @since 7.2.0
          def get_data_frame_transform(arguments = {})
            arguments = arguments.clone
            transform_id = URI.escape(arguments.delete(:transform_id))

            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify('_data_frame/transforms', Elasticsearch::API::Utils.__listify(transform_id))
            params = Elasticsearch::API::Utils.__validate_and_extract_params(arguments, ParamsRegistry.get(__method__))
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:get_data_frame_transform, [:from,
                                                              :size,
                                                              :allow_no_match].freeze)
        end
      end
    end
  end
end
