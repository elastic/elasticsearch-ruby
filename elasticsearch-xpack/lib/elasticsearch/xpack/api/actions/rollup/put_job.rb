# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions
          # Creates a rollup job.
          #
          # @option arguments [String] :id The ID of the job to create

          # @option arguments [Hash] :body The job configuration (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/rollup-put-job.html
          #
          def put_job(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_rollup/job/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
