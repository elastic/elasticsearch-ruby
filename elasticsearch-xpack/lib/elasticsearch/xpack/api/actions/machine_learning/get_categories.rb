# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Retrieve job results for one or more categories
          #
          # @option arguments [String] :job_id The name of the job (*Required*)
          # @option arguments [Long] :category_id The identifier of the category definition of interest
          # @option arguments [Hash] :body Category selection details if not provided in URI
          # @option arguments [Int] :from skips a number of categories
          # @option arguments [Int] :size specifies a max number of categories to get
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-get-category.html
          #
          def get_categories(arguments={})
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]
            method = Elasticsearch::API::HTTP_GET
            path   = Elasticsearch::API::Utils.__pathify "_xpack/ml/anomaly_detectors", arguments[:job_id], "results/categories", arguments[:category_id]
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:get_categories, [ :from,
                                                     :size ].freeze)
        end
      end
    end
  end
end
