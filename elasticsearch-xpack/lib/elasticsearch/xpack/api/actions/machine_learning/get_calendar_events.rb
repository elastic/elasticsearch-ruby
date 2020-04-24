# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :calendar_id The ID of the calendar containing the events (*Required*)
          # @option arguments [String] :job_id Get events for the job. When this option is used calendar_id must be '_all'
          # @option arguments [String] :start Get events after this time
          # @option arguments [Date] :end Get events before this time
          # @option arguments [Int] :from Skips a number of events
          # @option arguments [Int] :size Specifies a max number of events to get
          #
          # @see [TODO]
          #
          def get_calendar_events(arguments={})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]
            valid_params = [
              :calendar_id,
              :job_id,
              :start,
              :end,
              :from,
              :size ]

            arguments = arguments.clone
            calendar_id = arguments.delete(:calendar_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/calendars/#{calendar_id}/events"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
