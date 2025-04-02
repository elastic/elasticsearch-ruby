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
# Auto generated from commit 3e97c19ea994ba17fbdaa94e813b27c345f9bbbd
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Actions
      # Throttle a delete by query operation.
      # Change the number of requests per second for a particular delete by query operation.
      # Rethrottling that speeds up the query takes effect immediately but rethrotting that slows down the query takes effect after completing the current batch to prevent scroll timeouts.
      #
      # @option arguments [String, Integer] :task_id The ID for the task. (*Required*)
      # @option arguments [Float] :requests_per_second The throttle for this request in sub-requests per second.
      #  To disable throttling, set it to +-1+.
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-by-query-rethrottle
      #
      def delete_by_query_rethrottle(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'delete_by_query_rethrottle' }

        defined_params = [:task_id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'task_id' missing" unless arguments[:task_id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = nil

        _task_id = arguments.delete(:task_id)

        method = Elasticsearch::API::HTTP_POST
        path   = "_delete_by_query/#{Utils.listify(_task_id)}/_rethrottle"
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
