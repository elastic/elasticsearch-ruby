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
    module Actions
      # Creates a new document in the index.
      #
      # Returns a 409 response when a document with a same ID already exists in the index.
      #
      # @option arguments [String] :id Document ID
      # @option arguments [String] :index The name of the index
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the index operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` (the default) then do nothing with refreshes. (options: true, false, wait_for)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte)
      # @option arguments [String] :pipeline The pipeline id to preprocess incoming documents with
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The document (*Required*)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/docs-index_.html
      #
      def create(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'create' }

        defined_params = %i[index id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        if arguments[:id]
          index arguments.update op_type: 'create'
        else
          index arguments
        end
      end
    end
  end
end
