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
  module Helpers
    # Elasticsearch Client Helper for the ES|QL API
    #
    # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/esql-query-api.html
    #
    module ESQLHelper
      # Query helper for ES|QL
      #
      # By default, the `esql.query` API returns a Hash response with the following keys:
      #
      # * `columns` with the value being an Array of `{ name: type }` Hashes for each column.
      #
      # * `values` with the value being an Array of Arrays with the values for each row.
      #
      # This helper function returns an Array of hashes with the columns as keys and the respective
      # values: `{ column['name'] => value }`.
      #
      # @param client [Elasticsearch::Client] an instance of the Client to use for the query.
      # @param query [Hash, String] The query to be passed to the ES|QL query API.
      # @param params [Hash] options to pass to the ES|QL query API.
      # @param parser [Hash] Hash of column name keys and Proc values to transform the value of
      #   a given column.
      # @example Using the ES|QL helper
      #   require 'elasticsearch/helpers/esql_helper'
      #   query = <<~ESQL
      #             FROM sample_data
      #             | EVAL duration_ms = ROUND(event.duration / 1000000.0, 1)
      #           ESQL
      #   response = Elasticsearch::Helpers::ESQLHelper.query(client, query)
      #
      # @example Using the ES|QL helper with a parser
      #     response = Elasticsearch::Helpers::ESQLHelper.query(
      #                  client,
      #                  query,
      #                  parser: { '@timestamp' => Proc.new { |t| DateTime.parse(t) } }
      #                )
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/client/ruby-api/current/Helpers.html#_esql_helper
      #
      def self.query(client, query, params = {}, parser: {})
        response = client.esql.query({ body: { query: query }, format: 'json' }.merge(params))

        columns = response['columns']
        response['values'].map do |value|
          (value.length - 1).downto(0).map do |index|
            key = columns[index]['name']
            value[index] = parser[key].call(value[index]) if value[index] && parser[key]
            { key => value[index] }
          end.reduce({}, :merge)
        end
      end
    end
  end
end
