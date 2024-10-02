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
      # Allows to perform multiple index/update/delete operations in a single request.
      #
      # @option arguments [String] :index Default index for items which don't provide one
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the bulk operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` (the default) then do nothing with refreshes. (options: true, false, wait_for)
      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [String] :type Default document type for items which don't provide one
      # @option arguments [List] :_source True or false to return the _source field or not, or default list of fields to return, can be overridden on each sub-request
      # @option arguments [List] :_source_excludes Default list of fields to exclude from the returned _source field, can be overridden on each sub-request
      # @option arguments [List] :_source_includes Default list of fields to extract and return from the _source field, can be overridden on each sub-request
      # @option arguments [String] :pipeline The pipeline id to preprocess incoming documents with
      # @option arguments [Boolean] :require_alias Sets require_alias for all incoming documents. Defaults to unset (false)
      # @option arguments [Boolean] :require_data_stream When true, requires the destination to be a data stream (existing or to-be-created). Default is false
      # @option arguments [Boolean] :list_executed_pipelines Sets list_executed_pipelines for all incoming documents. Defaults to unset (false)
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [String|Array] :body The operation definition and data (action-data pairs), separated by newlines. Array of Strings, Header/Data pairs,
      # or the conveniency "combined" format can be passed, refer to Elasticsearch::API::Utils.__bulkify documentation.
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/docs-bulk.html
      #
      def bulk(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'bulk' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body   = arguments.delete(:body)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_POST
        path   = if _index
                   "#{Utils.__listify(_index)}/_bulk"
                 else
                   '_bulk'
                 end
        params = Utils.process_params(arguments)

        payload = if body.is_a? Array
                    Elasticsearch::API::Utils.__bulkify(body)
                  else
                    body
                  end

        headers.merge!('Content-Type' => 'application/x-ndjson')
        Elasticsearch::API::Response.new(
          perform_request(method, path, params, payload, headers, request_opts)
        )
      end
    end
  end
end
