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
        # Start a trial.
        # Start a 30-day trial, which gives access to all subscription features.
        # NOTE: You are allowed to start a trial only if your cluster has not already activated a trial for the current major product version.
        # For example, if you have already activated a trial for v8.0, you cannot start a new trial until v9.0. You can, however, request an extended trial at https://www.elastic.co/trialextension.
        # To check the status of your trial, use the get trial status API.
        #
        # @option arguments [Boolean] :acknowledge whether the user has acknowledged acknowledge messages (default: false)
        # @option arguments [String] :type_query_string [TODO]
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-license-post-start-trial
        #
        def post_start_trial(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'license.post_start_trial' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_license/start_trial'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
