module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :id The ID of the job to create (*Required*)
          # @option arguments [Hash] :body The job configuration (*Required*)
          #
          # @see
          #
          def put_job(arguments={})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/rollup/job/#{arguments[:id]}"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
