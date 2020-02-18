# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Preview a datafeed
          #
          # @option arguments [String] :datafeed_id The ID of the datafeed to preview (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-preview-datafeed.html
          #
          def preview_datafeed(arguments = {})
            raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/datafeeds/#{arguments[:datafeed_id]}/_preview"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
