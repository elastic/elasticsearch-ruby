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
    module CrossClusterReplication
      module Actions
        # Forget a follower.
        # Remove the cross-cluster replication follower retention leases from the leader.
        # A following index takes out retention leases on its leader index.
        # These leases are used to increase the likelihood that the shards of the leader index retain the history of operations that the shards of the following index need to run replication.
        # When a follower index is converted to a regular index by the unfollow API (either by directly calling the API or by index lifecycle management tasks), these leases are removed.
        # However, removal of the leases can fail, for example when the remote cluster containing the leader index is unavailable.
        # While the leases will eventually expire on their own, their extended existence can cause the leader index to hold more history than necessary and prevent index lifecycle management from performing some operations on the leader index.
        # This API exists to enable manually removing the leases when the unfollow API is unable to do so.
        # NOTE: This API does not stop replication by a following index. If you use this API with a follower index that is still actively following, the following index will add back retention leases on the leader.
        # The only purpose of this API is to handle the case of failure to remove the following retention leases after the unfollow API is invoked.
        #
        # @option arguments [String] :index the name of the leader index for which specified follower retention leases should be removed (*Required*)
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ccr-forget-follower
        #
        def forget_follower(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ccr.forget_follower' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.listify(_index)}/_ccr/forget_follower"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
