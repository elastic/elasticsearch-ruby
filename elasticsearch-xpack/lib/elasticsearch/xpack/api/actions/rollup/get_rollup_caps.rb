# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions
          # Returns the capabilities of any rollup jobs that have been configured for a specific index or index pattern.
          #
          # @option arguments [String] :id The ID of the index to check rollup capabilities on, or left blank for all jobs
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/rollup-get-rollup-caps.html
          #
          def get_rollup_caps(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _id
                       "_rollup/data/#{Elasticsearch::API::Utils.__listify(_id)}"
                     else
                       "_rollup/data"
            end
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
