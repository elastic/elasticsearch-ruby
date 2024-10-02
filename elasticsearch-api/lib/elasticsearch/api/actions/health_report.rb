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
    module Actions
      # Returns the health of the cluster.
      #
      # @option arguments [String] :feature A feature of the cluster, as returned by the top-level health API
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Boolean] :verbose Opt in for more information about the health of the system
      # @option arguments [Integer] :size Limit the number of affected resources the health API returns
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/health-api.html
      #
      def health_report(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'health_report' }

        defined_params = [:feature].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = nil

        _feature = arguments.delete(:feature)

        method = Elasticsearch::API::HTTP_GET
        path   = if _feature
                   "_health_report/#{Utils.__listify(_feature)}"
                 else
                   '_health_report'
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
