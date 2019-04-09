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
  module API
    module Actions

      # The Painless execute API allows an arbitrary script to be executed and a result to be returned.
      #
      # @option arguments [Hash] :body The script to execute
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/painless/master/painless-execute-api.html
      #
      def scripts_painless_execute(arguments={})
        method = Elasticsearch::API::HTTP_GET
        path   = "_scripts/painless/_execute"
        params = {}
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end
    end
  end
end
