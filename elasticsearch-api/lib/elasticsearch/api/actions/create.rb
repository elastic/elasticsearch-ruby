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

      # Create a new document.
      #
      # The API will create new document, if it doesn't exist yet -- in that case, it will return
      # a `409` error (`version_conflict_engine_exception`).
      #
      # You can leave out the `:id` parameter for the ID to be generated automatically
      #
      # @example Create a document with an ID
      #
      #     client.create index: 'myindex',
      #                  type: 'doc',
      #                  id: '1',
      #                  body: {
      #                   title: 'Test 1'
      #                 }
      #
      # @example Create a document with an auto-generated ID
      #
      #     client.create index: 'myindex',
      #                  type: 'doc',
      #                  body: {
      #                   title: 'Test 1'
      #                 }
      #
      # @option (see Actions#index)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-index_.html#_automatic_id_generation
      #
      def create(arguments={})
        if arguments[:id]
          index arguments.update :op_type => 'create'
        else
          index arguments
        end
      end
    end
  end
end
