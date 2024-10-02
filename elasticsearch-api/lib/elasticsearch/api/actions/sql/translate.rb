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
#
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module SQL
      module Actions
        # Translates SQL into Elasticsearch queries
        #
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body Specify the query in the `query` element. (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/sql-translate-api.html
        #
        def translate(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'sql.translate' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_sql/translate'
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
