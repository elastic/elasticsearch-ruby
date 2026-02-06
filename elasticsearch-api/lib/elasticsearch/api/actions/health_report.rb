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
    module Actions
      # Get the cluster health.
      # Get a report with the health status of an Elasticsearch cluster.
      # The report contains a list of indicators that compose Elasticsearch functionality.
      # Each indicator has a health status of: green, unknown, yellow or red.
      # The indicator will provide an explanation and metadata describing the reason for its current health status.
      # The cluster’s status is controlled by the worst indicator status.
      # In the event that an indicator’s status is non-green, a list of impacts may be present in the indicator result which detail the functionalities that are negatively affected by the health issue.
      # Each impact carries with it a severity level, an area of the system that is affected, and a simple description of the impact on the system.
      # Some health indicators can determine the root cause of a health problem and prescribe a set of steps that can be performed in order to improve the health of the system.
      # The root cause and remediation steps are encapsulated in a diagnosis.
      # A diagnosis contains a cause detailing a root cause analysis, an action containing a brief description of the steps to take to fix the problem, the list of affected resources (if applicable), and a detailed step-by-step troubleshooting guide to fix the diagnosed problem.
      # NOTE: The health indicators perform root cause analysis of non-green health statuses. This can be computationally expensive when called frequently.
      # When setting up automated polling of the API for health status, set verbose to false to disable the more expensive analysis logic.
      #
      # @option arguments [String, Array<String>] :feature A feature of the cluster, as returned by the top-level health report API.
      # @option arguments [Time] :timeout Explicit operation timeout.
      # @option arguments [Boolean] :verbose Opt-in for more information about the health of the system. Server default: true.
      # @option arguments [Integer] :size Limit the number of affected resources the health report API returns. Server default: 1000.
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
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-health-report
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
                   "_health_report/#{Utils.listify(_feature)}"
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
