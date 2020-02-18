# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :index The rollup index or index pattern to obtain rollup capabilities from.

          #
          # @see
          #
          def get_rollup_index_caps(arguments = {})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            arguments = arguments.clone

            _index = arguments.delete(:index)

            method = Elasticsearch::API::HTTP_GET
            path   = "#{Elasticsearch::API::Utils.__listify(_index)}/_rollup/data"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
