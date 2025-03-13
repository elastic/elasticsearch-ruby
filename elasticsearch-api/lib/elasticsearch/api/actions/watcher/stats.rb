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
    module Watcher
      module Actions
        # Get Watcher statistics.
        # This API always returns basic metrics.
        # You retrieve more metrics by using the metric parameter.
        #
        # @option arguments [Watchermetric] :metric Defines which additional metrics are included in the response.
        # @option arguments [Boolean] :emit_stacktraces Defines whether stack traces are generated for each watch that is running.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-watcher-stats
        #
        def stats(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'watcher.stats' }

          defined_params = [:metric].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _metric = arguments.delete(:metric)

          method = Elasticsearch::API::HTTP_GET
          path   = if _metric
                     "_watcher/stats/#{Utils.listify(_metric)}"
                   else
                     '_watcher/stats'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
