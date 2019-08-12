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
          # @option arguments [String] :calendar_id The ID of the calendar to fetch
          # @option arguments [Int] :from skips a number of calendars
          # @option arguments [Int] :size specifies a max number of calendars to get
          #
          # @see [TODO]
          #
          def get_calendars(arguments={})
            arguments = arguments.clone
            calendar_id = arguments.delete(:calendar_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/calendars/#{calendar_id}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:get_calendars, [ :calendar_id,
                                                    :from,
                                                    :size ].freeze)
        end
      end
    end
  end
end
