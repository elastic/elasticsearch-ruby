# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Instantiates a calendar.
          #
          # @option arguments [String] :calendar_id The ID of the calendar to create

          # @option arguments [Hash] :body The calendar details
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-put-calendar.html
          #
          def put_calendar(arguments = {})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]

            arguments = arguments.clone

            _calendar_id = arguments.delete(:calendar_id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_ml/calendars/#{Elasticsearch::API::Utils.__listify(_calendar_id)}"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
