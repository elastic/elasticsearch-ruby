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
          # Posts scheduled events in a calendar.
          #
          # @option arguments [String] :calendar_id The ID of the calendar to modify
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body A list of events (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-post-calendar-event.html
          #
          def post_calendar_events(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _calendar_id = arguments.delete(:calendar_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/calendars/#{Elasticsearch::API::Utils.__listify(_calendar_id)}/events"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
        end
      end
    end
  end
end
