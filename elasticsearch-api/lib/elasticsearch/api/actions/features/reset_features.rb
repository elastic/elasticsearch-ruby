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
    module Features
      module Actions
        # Reset the features.
        # Clear all of the state information stored in system indices by Elasticsearch features, including the security and machine learning indices.
        # WARNING: Intended for development and testing use only. Do not reset features on a production cluster.
        # Return a cluster to the same state as a new installation by resetting the feature state for all Elasticsearch features.
        # This deletes all state information stored in system indices.
        # The response code is HTTP 200 if the state is successfully reset for all features.
        # It is HTTP 500 if the reset operation failed for any feature.
        # Note that select features might provide a way to reset particular system indices.
        # Using this API resets all features, both those that are built-in and implemented as plugins.
        # To list the features that will be affected, use the get features API.
        # IMPORTANT: The features installed on the node you submit this request to are the features that will be reset. Run on the master node if you have any doubts about which plugins are installed on individual nodes.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-features-reset-features
        #
        def reset_features(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'features.reset_features' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_POST
          path   = '_features/_reset'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
