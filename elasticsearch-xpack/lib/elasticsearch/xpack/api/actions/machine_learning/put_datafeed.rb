# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Instantiates a datafeed.
          #
          # @option arguments [String] :datafeed_id The ID of the datafeed to create
          # @option arguments [Boolean] :ignore_unavailable Ignore unavailable indexes (default: false)
          # @option arguments [Boolean] :allow_no_indices Ignore if the source indices expressions resolves to no concrete indices (default: true)
          # @option arguments [Boolean] :ignore_throttled Ignore indices that are marked as throttled (default: true)
          # @option arguments [String] :expand_wildcards Whether source index expressions should get expanded to open or closed indices (default: open)
          #   (options: open,closed,hidden,none,all)

          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The datafeed config (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-put-datafeed.html
          #
          def put_datafeed(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _datafeed_id = arguments.delete(:datafeed_id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_ml/datafeeds/#{Elasticsearch::API::Utils.__listify(_datafeed_id)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:put_datafeed, [
            :ignore_unavailable,
            :allow_no_indices,
            :ignore_throttled,
            :expand_wildcards
          ].freeze)
      end
    end
    end
  end
end
