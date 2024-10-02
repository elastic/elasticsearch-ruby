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
      # Removes a document from the index.
      #
      # @option arguments [String] :id The document ID
      # @option arguments [String] :index The name of the index
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the delete operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` (the default) then do nothing with refreshes. (options: true, false, wait_for)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Number] :if_seq_no only perform the delete operation if the last operation that has changed the document has the specified sequence number
      # @option arguments [Number] :if_primary_term only perform the delete operation if the last operation that has changed the document has the specified primary term
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte)
      # @option arguments [Hash] :headers Custom HTTP headers
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/docs-delete.html
      #
      def delete(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'delete' }

        defined_params = %i[index id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = nil

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_DELETE
        path   = "#{Utils.__listify(_index)}/_doc/#{Utils.__listify(_id)}"
        params = Utils.process_params(arguments)

        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found do
            Elasticsearch::API::Response.new(
              perform_request(method, path, params, body, headers, request_opts)
            )
          end
        else
          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
