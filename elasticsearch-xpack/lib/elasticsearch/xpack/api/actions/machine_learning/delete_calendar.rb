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
          # @option arguments [String] :calendar_id The ID of the calendar to delete (*Required*)
          #
          # @see [TODO]
          #
          def delete_calendar(arguments = {})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_xpack/ml/calendars/#{arguments[:calendar_id]}"
            params = {}
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
