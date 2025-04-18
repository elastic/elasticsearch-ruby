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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module SnapshotLifecycleManagement
      module Actions
        # Start snapshot lifecycle management.
        # Snapshot lifecycle management (SLM) starts automatically when a cluster is formed.
        # Manually starting SLM is necessary only if it has been stopped using the stop SLM API.
        #
        # @option arguments [Time] :master_timeout The period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Time] :timeout The period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-slm-start
        #
        def start(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'slm.start' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_slm/start'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
