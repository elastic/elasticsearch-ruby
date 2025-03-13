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
        # Get the features.
        # Get a list of features that can be included in snapshots using the +feature_states+ field when creating a snapshot.
        # You can use this API to determine which feature states to include when taking a snapshot.
        # By default, all feature states are included in a snapshot if that snapshot includes the global state, or none if it does not.
        # A feature state includes one or more system indices necessary for a given feature to function.
        # In order to ensure data integrity, all system indices that comprise a feature state are snapshotted and restored together.
        # The features listed by this API are a combination of built-in features and features defined by plugins.
        # In order for a feature state to be listed in this API and recognized as a valid feature state by the create snapshot API, the plugin that defines that feature must be installed on the master node.
        #
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-features-get-features
        #
        def get_features(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'features.get_features' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_features'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
