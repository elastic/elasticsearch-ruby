module Elasticsearch
  module XPack
    module API
      module SQL
        module Actions

          # TODO: Description
          #
          # @option arguments [Hash] :body Use the `query` element to start a query. Use the `cursor` element to continue a query. (*Required*)
          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
          #
          # @see Execute SQL
          #
          def query(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            valid_params = [
              :format ]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/sql"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
