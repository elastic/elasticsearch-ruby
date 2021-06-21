# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
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
          # Retrieves configuration information for calendars.
          #
          # @option arguments [String] :calendar_id The ID of the calendar to fetch
          # @option arguments [Int] :from skips a number of calendars
          # @option arguments [Int] :size specifies a max number of calendars to get
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The from and size parameters optionally sent in the body
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/ml-get-calendar.html
          #
          def get_calendars(arguments = {})
            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _calendar_id = arguments.delete(:calendar_id)

            method = if arguments[:body]
                       Elasticsearch::API::HTTP_POST
                     else
                       Elasticsearch::API::HTTP_GET
                     end

            path = if _calendar_id
                     "_ml/calendars/#{Elasticsearch::API::Utils.__listify(_calendar_id)}"
                   else
                     "_ml/calendars"
                   end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:get_calendars, [
            :from,
            :size
          ].freeze)
        end
      end
    end
  end
end
