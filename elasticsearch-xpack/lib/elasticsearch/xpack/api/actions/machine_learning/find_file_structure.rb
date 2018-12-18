module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Send data to an anomaly detection job for analysis
          #
          # @option arguments [Hash] :body The contents of the file to be analyzed (*Required*)
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-file-structure.html
          #
          def find_file_structure(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/find_file_structure"
            body = Elasticsearch::API::Utils.__bulkify(arguments.delete(:body))

            perform_request(method, path, arguments, body).body
          end
        end
      end
    end
  end
end
