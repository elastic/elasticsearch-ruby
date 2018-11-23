# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
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

          # TODO: Description
          #
          # @option arguments [String] :calendar_id The ID of the calendar to fetch
          # @option arguments [Int] :from skips a number of calendars
          # @option arguments [Int] :size specifies a max number of calendars to get
          #
          # @see [TODO]
          #
          def get_calendars(arguments={})
            valid_params = [
              :calendar_id,
              :from,
              :size ]

            arguments = arguments.clone
            calendar_id = arguments.delete(:calendar_id)

            method = Elasticsearch::API::HTTP_GET
            path   = "_xpack/ml/calendars/#{calendar_id}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
            body   = nil

            perform_request(method, path, params, body).body
          end
        end
      end
    end
  end
end
