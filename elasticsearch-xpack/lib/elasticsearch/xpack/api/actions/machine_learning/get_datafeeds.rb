# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Retrieve configuration information for datafeeds
          #
          # @option arguments [String] :datafeed_id The ID of the datafeeds stats to fetch
          # @option arguments [Boolean] :allow_no_datafeeds Whether to ignore if a wildcard expression matches no datafeeds. (This includes `_all` string or when no datafeeds have been specified)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-datafeed.html
          #
          def get_datafeeds(arguments={})
            valid_params = [
              :allow_no_datafeeds ]

            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify "_ml/datafeeds", arguments[:datafeed_id]
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
