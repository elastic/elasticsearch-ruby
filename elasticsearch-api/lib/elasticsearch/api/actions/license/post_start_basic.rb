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
    module License
      module Actions
        # Start a basic license.
        # Start an indefinite basic license, which gives access to all the basic features.
        # NOTE: In order to start a basic license, you must not currently have a basic license.
        # If the basic license does not support all of the features that are available with your current license, however, you are notified in the response.
        # You must then re-submit the API request with the +acknowledge+ parameter set to +true+.
        # To check the status of your basic license, use the get basic license API.
        #
        # @option arguments [Boolean] :acknowledge whether the user has acknowledged acknowledge messages (default: false)
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-license-post-start-basic
        #
        def post_start_basic(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'license.post_start_basic' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_license/start_basic'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
