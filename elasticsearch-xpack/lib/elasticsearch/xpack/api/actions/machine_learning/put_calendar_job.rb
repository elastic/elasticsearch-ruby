# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Adds an anomaly detection job to a calendar.
          #
          # @option arguments [String] :calendar_id The ID of the calendar to modify
          # @option arguments [String] :job_id The ID of the job to add to the calendar
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-put-calendar-job.html
          #
          def put_calendar_job(arguments = {})
            raise ArgumentError, "Required argument 'calendar_id' missing" unless arguments[:calendar_id]
            raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _calendar_id = arguments.delete(:calendar_id)

            _job_id = arguments.delete(:job_id)

            method = Elasticsearch::API::HTTP_PUT
            path   = "_ml/calendars/#{Elasticsearch::API::Utils.__listify(_calendar_id)}/jobs/#{Elasticsearch::API::Utils.__listify(_job_id)}"
            params = {}

            body = nil
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
