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
    module MachineLearning
      module Actions
        # Deletes scheduled events from a calendar.
        #
        # @option arguments [String] :calendar_id The ID of the calendar to modify
        # @option arguments [String] :event_id The ID of the event to remove from the calendar
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/ml-delete-calendar-event.html
        #
        def delete_calendar_event(arguments = {})
          raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]
          raise ArgumentError, "Required argument 'event_id' missing" unless arguments[:event_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _calendar_id = arguments.delete(:calendar_id)

          _event_id = arguments.delete(:event_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_ml/calendars/#{Utils.__listify(_calendar_id)}/events/#{Utils.__listify(_event_id)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
