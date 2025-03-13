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
        # Delete events from a calendar.
        #
        # @option arguments [String] :calendar_id A string that uniquely identifies a calendar. (*Required*)
        # @option arguments [String] :event_id Identifier for the scheduled event.
        #  You can obtain this identifier by using the get calendar events API. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-delete-calendar-event
        #
        def delete_calendar_event(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_calendar_event' }

          defined_params = [:calendar_id, :event_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]
          raise ArgumentError, "Required argument 'event_id' missing" unless arguments[:event_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _calendar_id = arguments.delete(:calendar_id)

          _event_id = arguments.delete(:event_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_ml/calendars/#{Utils.listify(_calendar_id)}/events/#{Utils.listify(_event_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
