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

module Elasticsearch
  module API
    module Actions
      # The value of requests_per_second can be changed on a running delete by query using the _rethrottle API
      #
      # @option arguments [String] :task_id The task id to rethrottle (*Required*)
      # @option arguments [Number] :requests_per_second The throttle to set on this request in floating sub-requests per second. -1 means set no throttle.
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-delete-by-query.html
      #
      def delete_by_query_rethrottle(arguments = {})
        raise ArgumentError, "Required argument 'task_id' missing" unless arguments[:task_id]

        method = Elasticsearch::API::HTTP_POST
        path   = "_delete_by_query/#{arguments[:task_id]}/_rethrottle"
        params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = nil

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:delete_by_query_rethrottle, [
        :requests_per_second
      ].freeze)
    end
  end
end
