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
      # By default, the `query` API returns a Hash response with a `columns` key whose value is an
      # Array of { name: type } Hashes for each column and a `values` key whose value is an Array of
      # Arrays with the values for each row.
      # This helper function returns an Array of hashes with the columns as keys and the respective
      # values: { column['name'] => value }
      #
      def self.query(client, query, params = {})
        response = client.esql.query({ body: { query: query }, format: 'json' }.merge(params))

        columns = response['columns']
        response['values'].map do |value|
          (value.length - 1).downto(0).map do |index|
            { columns[index]['name'] => value[index] }
          end.reduce({}, :merge)
        end
      end
    end
  end
end
