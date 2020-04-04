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
          # @option arguments [String] :datafeed_id The ID of the datafeed to stop
          # @option arguments [Boolean] :allow_no_datafeeds Whether to ignore if a wildcard expression matches no datafeeds. (This includes `_all` string or when no datafeeds have been specified)
          # @option arguments [Boolean] :force True if the datafeed should be forcefully stopped.
          # @option arguments [Time] :timeout Controls the time to wait until a datafeed has stopped. Default to 20 seconds

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-stop-datafeed.html
          #
          def stop_datafeed(arguments = {})
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

            arguments = arguments.clone

            _datafeed_id = arguments.delete(:datafeed_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/datafeeds/#{Elasticsearch::API::Utils.__listify(_datafeed_id)}/_stop"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:stop_datafeed, [
            :allow_no_datafeeds,
            :force,
            :timeout
          ].freeze)
      end
    end
    end
  end
end
