module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Retrieve usage information for datafeeds
          #
          # @option arguments [String] :datafeed_id The ID of the datafeeds stats to fetch
          # @option arguments [Boolean] :allow_no_datafeeds Whether to ignore if a wildcard expression matches no datafeeds. (This includes `_all` string or when no datafeeds have been specified)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-datafeed-stats.html
          #
          def get_datafeed_stats(arguments={})
            valid_params = [
              :allow_no_datafeeds ]

            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify "_xpack/ml/datafeeds", arguments[:datafeed_id], "/_stats"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
