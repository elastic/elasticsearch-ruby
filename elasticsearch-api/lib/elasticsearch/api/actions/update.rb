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
    module Actions
      # Update a document.
      # Update a document by running a script or passing a partial document.
      # If the Elasticsearch security features are enabled, you must have the +index+ or +write+ index privilege for the target index or index alias.
      # The script can update, delete, or skip modifying the document.
      # The API also supports passing a partial document, which is merged into the existing document.
      # To fully replace an existing document, use the index API.
      # This operation:
      # * Gets the document (collocated with the shard) from the index.
      # * Runs the specified script.
      # * Indexes the result.
      # The document must still be reindexed, but using this API removes some network roundtrips and reduces chances of version conflicts between the GET and the index operation.
      # The +_source+ field must be enabled to use this API.
      # In addition to +_source+, you can access the following variables through the +ctx+ map: +_index+, +_type+, +_id+, +_version+, +_routing+, and +_now+ (the current timestamp).
      #
      # @option arguments [String] :id A unique identifier for the document to be updated. (*Required*)
      # @option arguments [String] :index The name of the target index.
      #  By default, the index is created automatically if it doesn't exist. (*Required*)
      # @option arguments [Integer] :if_primary_term Only perform the operation if the document has this primary term.
      # @option arguments [Integer] :if_seq_no Only perform the operation if the document has this sequence number.
      # @option arguments [Boolean] :include_source_on_error True or false if to include the document source in the error message in case of parsing errors. Server default: true.
      # @option arguments [String] :lang The script language. Server default: painless.
      # @option arguments [String] :refresh If 'true', Elasticsearch refreshes the affected shards to make this operation visible to search.
      #  If 'wait_for', it waits for a refresh to make this operation visible to search.
      #  If 'false', it does nothing with refreshes. Server default: false.
      # @option arguments [Boolean] :require_alias If +true+, the destination must be an index alias.
      # @option arguments [Integer] :retry_on_conflict The number of times the operation should be retried when a conflict occurs. Server default: 0.
      # @option arguments [String] :routing A custom value used to route operations to a specific shard.
      # @option arguments [Time] :timeout The period to wait for the following operations: dynamic mapping updates and waiting for active shards.
      #  Elasticsearch waits for at least the timeout period before failing.
      #  The actual wait time could be longer, particularly when multiple waits occur. Server default: 1m.
      # @option arguments [Integer, String] :wait_for_active_shards The number of copies of each shard that must be active before proceeding with the operation.
      #  Set to 'all' or any positive integer up to the total number of shards in the index (+number_of_replicas++1).
      #  The default value of +1+ means it waits for each primary shard to be active. Server default: 1.
      # @option arguments [Boolean, String, Array<String>] :_source If +false+, source retrieval is turned off.
      #  You can also specify a comma-separated list of the fields you want to retrieve. Server default: true.
      # @option arguments [String, Array<String>] :_source_excludes The source fields you want to exclude.
      # @option arguments [String, Array<String>] :_source_includes The source fields you want to retrieve.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update
      #
      def update(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'update' }

        defined_params = [:index, :id].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _id = arguments.delete(:id)

        _index = arguments.delete(:index)

        method = Elasticsearch::API::HTTP_POST
        path   = "#{Utils.listify(_index)}/_update/#{Utils.listify(_id)}"
        params = Utils.process_params(arguments)

        if Array(arguments[:ignore]).include?(404)
          Utils.rescue_from_not_found do
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
