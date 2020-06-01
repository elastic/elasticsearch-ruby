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
  module XPack
    module API
      module MachineLearning
        module Actions
          # Retrieves information about the scheduled events in calendars.
          #
          # @option arguments [String] :calendar_id The ID of the calendar containing the events
          # @option arguments [String] :job_id Get events for the job. When this option is used calendar_id must be '_all'
          # @option arguments [String] :start Get events after this time
          # @option arguments [Date] :end Get events before this time
          # @option arguments [Int] :from Skips a number of events
          # @option arguments [Int] :size Specifies a max number of events to get
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/ml-get-calendar-event.html
          #
          def get_calendar_events(arguments = {})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _calendar_id = arguments.delete(:calendar_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_ml/calendars/#{Elasticsearch::API::Utils.__listify(_calendar_id)}/events"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_calendar_events, [
            :job_id,
            :start,
            :end,
            :from,
            :size
          ].freeze)
      end
    end
    end
  end
end
