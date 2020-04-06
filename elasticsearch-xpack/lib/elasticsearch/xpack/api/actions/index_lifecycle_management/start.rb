# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module IndexLifecycleManagement
        module Actions
          # Start the index lifecycle management (ILM) plugin.
          #

          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ilm-start.html
          #
          def start(arguments = {})
            arguments = arguments.clone

            method = Elasticsearch::API::HTTP_POST
            path   = "_ilm/start"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
