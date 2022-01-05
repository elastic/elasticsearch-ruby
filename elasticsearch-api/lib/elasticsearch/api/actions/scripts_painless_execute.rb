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
      # Allows an arbitrary script to be executed and a result to be returned
      # This functionality is Experimental and may be changed or removed
      # completely in a future release. Elastic will take a best effort approach
      # to fix any issues, but experimental features are not subject to the
      # support SLA of official GA features.
      #
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The script to execute
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/painless/7.17/painless-execute-api.html
      #
      def scripts_painless_execute(arguments = {})
        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        method = if arguments[:body]
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path   = "_scripts/painless/_execute"
        params = {}

        body = arguments[:body]
        perform_request(method, path, params, body, headers).body
      end
    end
  end
end
