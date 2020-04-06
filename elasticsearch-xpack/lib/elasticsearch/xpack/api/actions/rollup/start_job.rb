# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions
          # Starts an existing, stopped rollup job.
          #
          # @option arguments [String] :id The ID of the job to start

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/rollup-start-job.html
          #
          def start_job(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_rollup/job/#{Elasticsearch::API::Utils.__listify(_id)}/_start"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
