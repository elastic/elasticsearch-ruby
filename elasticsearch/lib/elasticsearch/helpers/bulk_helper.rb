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
    class BulkHelper
      def initialize(client:, index:, params: {})
        @client = client
        @index = index
        @params = params
      end

      def ingest(docs, params = {})
        ingest_docs = docs.map do |doc|
          { index: { _index: @index, data: doc} }
        end
        @client.bulk({ body: ingest_docs }.merge(params.merge(@params)))
      end

      def delete(ids, params = {})
        to_delete = ids.map do |id|
          { delete: { _index: @index, _id: id} }
        end
        @client.bulk({ body: to_delete }.merge(params.merge(@params)))
      end

      def update(docs, params = {})
        ingest_docs = docs.map do |doc|
          { update: { _index: @index, _id: doc.delete('id'), data: { doc: doc } } }
        end
        @client.bulk({ body: ingest_docs }.merge(params.merge(@params)))
      end
    end
  end
end
