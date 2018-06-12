module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :calendar_id The ID of the calendar to modify (*Required*)
          # @option arguments [Hash] :body A list of events (*Required*)
          #
          # @see [TODO]
          #
          def post_calendar_events(arguments={})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_POST
            path   = "_xpack/ml/calendars/#{arguments[:calendar_id]}/events"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
