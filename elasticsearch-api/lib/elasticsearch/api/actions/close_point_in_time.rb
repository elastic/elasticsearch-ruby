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
  module API
    module Actions
      # Close a point in time
      #
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body a point-in-time id to close
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.14/point-in-time-api.html
      #
      def close_point_in_time(arguments = {})
        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        method = Elasticsearch::API::HTTP_DELETE
        path   = "_pit"
        params = {}

        body = arguments[:body]
        perform_request(method, path, params, body, headers).body
      end
    end
  end
end
