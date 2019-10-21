# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Estimates memory usage for the given data frame analytics config.
          #
          # @option arguments [Hash] :body Memory usage estimation definition (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/estimate-memory-usage-dfanalytics.html
          #
          def estimate_memory_usage(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/data_frame/analytics/_estimate_memory_usage"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
