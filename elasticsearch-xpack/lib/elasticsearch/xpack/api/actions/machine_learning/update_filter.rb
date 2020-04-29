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
          # Updates the description of a filter, adds items, or removes items.
          #
          # @option arguments [String] :filter_id The ID of the filter to update
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The filter update (*Required*)
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-update-filter.html
          #
          def update_filter(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'filter_id' missing" unless arguments[:filter_id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _filter_id = arguments.delete(:filter_id)

            method = Elasticsearch::API::HTTP_POST
            path   = "_ml/filters/#{Elasticsearch::API::Utils.__listify(_filter_id)}/_update"
            params = {}

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end
      end
    end
    end
  end
end
