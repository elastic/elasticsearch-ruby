module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # @option arguments [Hash] :body The detector (*Required*)
          #
          def validate_detector(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/anomaly_detectors/_validate/detector"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
