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
          # @option arguments [String] :calendar_id The ID of the calendar to modify
          # @option arguments [String] :job_id The ID of the job to remove from the calendar

          #
          # @see [TODO]
          #
          def delete_calendar_job(arguments = {})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            arguments = arguments.clone

            _calendar_id = arguments.delete(:calendar_id)

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/calendars/#{Elasticsearch::API::Utils.__listify(_calendar_id)}/jobs/#{Elasticsearch::API::Utils.__listify(_job_id)}"
            params = {}

            body = nil
            perform_request(method, path, params, body).body
          end
      end
    end
    end
  end
end
