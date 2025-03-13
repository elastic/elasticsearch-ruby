# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.
#
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module IndexLifecycleManagement
      module Actions
        # Stop the ILM plugin.
        # Halt all lifecycle management operations and stop the index lifecycle management plugin.
        # This is useful when you are performing maintenance on the cluster and need to prevent ILM from performing any actions on your indices.
        # The API returns as soon as the stop request has been acknowledged, but the plugin might continue to run until in-progress operations complete and the plugin can be safely stopped.
        # Use the get ILM status API to check whether ILM is running.
        #
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ilm-stop
        #
        def stop(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ilm.stop' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_ilm/stop'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
