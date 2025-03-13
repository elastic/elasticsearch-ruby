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
    module MachineLearning
      module Actions
        # Get info about events in calendars.
        #
        # @option arguments [String] :calendar_id A string that uniquely identifies a calendar. You can get information for multiple calendars by using a comma-separated list of ids or a wildcard expression. You can get information for all calendars by using +_all+ or +*+ or by omitting the calendar identifier. (*Required*)
        # @option arguments [String, Time] :end Specifies to get events with timestamps earlier than this time.
        # @option arguments [Integer] :from Skips the specified number of events. Server default: 0.
        # @option arguments [String] :job_id Specifies to get events for a specific anomaly detection job identifier or job group. It must be used with a calendar identifier of +_all+ or +*+.
        # @option arguments [Integer] :size Specifies the maximum number of events to obtain. Server default: 100.
        # @option arguments [String, Time] :start Specifies to get events with timestamps after this time.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-calendar-events
        #
        def get_calendar_events(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_calendar_events' }

          defined_params = [:calendar_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _calendar_id = arguments.delete(:calendar_id)

          method = Elasticsearch::API::HTTP_GET
          path   = "_ml/calendars/#{Utils.listify(_calendar_id)}/events"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
