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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module DanglingIndices
      module Actions
        # Delete a dangling index.
        # If Elasticsearch encounters index data that is absent from the current cluster state, those indices are considered to be dangling.
        # For example, this can happen if you delete more than `cluster.indices.tombstones.size` indices while an Elasticsearch node is offline.
        #
        # @option arguments [String] :index_uuid The UUID of the index to delete. Use the get dangling indices API to find the UUID. (*Required*)
        # @option arguments [Boolean] :accept_data_loss This parameter must be set to true to acknowledge that it will no longer be possible to recove data from the dangling index.
        # @option arguments [Time] :master_timeout Specify timeout for connection to master Server default: 30s.
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-dangling-indices-delete-dangling-index
        #
        def delete_dangling_index(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'dangling_indices.delete_dangling_index' }

          defined_params = [:index_uuid].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index_uuid' missing" unless arguments[:index_uuid]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index_uuid = arguments.delete(:index_uuid)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_dangling/#{Utils.listify(_index_uuid)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
