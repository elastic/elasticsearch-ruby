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
# Auto generated from commit f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Esql
      module Actions
        # Run an ES|QL query.
        # Get search results for an ES|QL (Elasticsearch query language) query.
        # This functionality is subject to potential breaking changes within a
        # minor version, meaning that your referencing code may break when this
        # library is upgraded.
        #
        # @option arguments [String] :format A short version of the Accept header, e.g. json, yaml.
        # @option arguments [String] :delimiter The character to use between values within a CSV row. Only valid for the CSV format.
        # @option arguments [Boolean] :drop_null_columns Should columns that are entirely +null+ be removed from the +columns+ and +values+ portion of the results?
        #  Defaults to +false+. If +true+ then the response will include an extra section under the name +all_columns+ which has the name of all columns.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/esql-rest.html
        #
        def query(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'esql.query' }

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          method = Elasticsearch::API::HTTP_POST
          path   = '_query'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
