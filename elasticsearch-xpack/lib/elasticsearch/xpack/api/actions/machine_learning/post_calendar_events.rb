# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Posts scheduled events in a calendar.
          #
          # @option arguments [String] :calendar_id The ID of the calendar to modify

          # @option arguments [Hash] :body A list of events (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-post-calendar-event.html
          #
          def post_calendar_events(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]

            arguments = arguments.clone

            _calendar_id = arguments.delete(:calendar_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/calendars/#{Elasticsearch::API::Utils.__listify(_calendar_id)}/events"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
