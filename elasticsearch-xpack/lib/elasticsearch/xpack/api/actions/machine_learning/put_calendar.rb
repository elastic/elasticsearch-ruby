module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # TODO: Description
          #
          # @option arguments [String] :calendar_id The ID of the calendar to create (*Required*)
          # @option arguments [Hash] :body The calendar details
          #
          # @see [TODO]
          #
          def put_calendar(arguments={})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]
            method = Elasticsearch::API::HTTP_PUT
            path   = "_xpack/ml/calendars/#{arguments[:calendar_id]}"
            params = {}
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
