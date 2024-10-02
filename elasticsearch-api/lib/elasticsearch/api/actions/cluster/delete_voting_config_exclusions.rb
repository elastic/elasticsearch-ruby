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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module Cluster
      module Actions
        # Clears cluster voting config exclusions.
        #
        # @option arguments [Boolean] :wait_for_removal Specifies whether to wait for all excluded nodes to be removed from the cluster before clearing the voting configuration exclusions list.
        # @option arguments [Time] :master_timeout Timeout for submitting request to master
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/voting-config-exclusions.html
        #
        def delete_voting_config_exclusions(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.delete_voting_config_exclusions' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          method = Elasticsearch::API::HTTP_DELETE
          path   = '_cluster/voting_config_exclusions'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
