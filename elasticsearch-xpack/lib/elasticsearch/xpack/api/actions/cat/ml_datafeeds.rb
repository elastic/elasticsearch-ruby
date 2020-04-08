# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Cat
        module Actions
          # Gets configuration and usage information about datafeeds.
          #
          # @option arguments [String] :datafeed_id The ID of the datafeeds stats to fetch
          # @option arguments [Boolean] :allow_no_datafeeds Whether to ignore if a wildcard expression matches no datafeeds. (This includes `_all` string or when no datafeeds have been specified)
          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
          # @option arguments [List] :h Comma-separated list of column names to display
          # @option arguments [Boolean] :help Return help information
          # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
          # @option arguments [String] :time The unit in which to display time values
          #   (options: d,h,m,s,ms,micros,nanos)

          # @option arguments [Boolean] :v Verbose mode. Display column headers
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cat-datafeeds.html
          #
          def ml_datafeeds(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _datafeed_id = arguments.delete(:datafeed_id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _datafeed_id
                       "_cat/ml/datafeeds/#{Elasticsearch::API::Utils.__listify(_datafeed_id)}"
                     else
                       "_cat/ml/datafeeds"
            end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:ml_datafeeds, [
            :allow_no_datafeeds,
            :format,
            :h,
            :help,
            :s,
            :time,
            :v
          ].freeze)
      end
    end
    end
  end
end
