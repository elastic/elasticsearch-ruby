# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module DataFrame
        module Actions

          # Stops one or more data frame transforms.
          #
          # @option arguments [String] :transform_id The id of the transform(s) to stop.
          # @option arguments [String] :timeout Controls the time to wait until the transform has stopped.
          #   Default to 30 seconds.
          # @option arguments [String] :wait_for_completion Whether to wait for the transform to fully stop before
          #   returning or not. Default to false.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/stop-data-frame-transform.html
          #
          # @since 7.2.0
          def stop_data_frame_transform(arguments={})
            raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]
            arguments = arguments.clone
            transform_id = URI.escape(arguments.delete(:transform_id))

            method = Elasticsearch::API::HTTP_POST
            path   = "_data_frame/transforms/#{Elasticsearch::API::Utils.__listify(transform_id)}/_stop"
            params = Elasticsearch::API::Utils.__validate_and_extract_params(arguments, ParamsRegistry.get(__method__))
            body   = nil

            perform_request(method, path, params, body).body
          end


          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:stop_data_frame_transform, [ :timeout,
                                                                :wait_for_completion,
                                                                :allow_no_match ].freeze)
        end
      end
    end
  end
end
