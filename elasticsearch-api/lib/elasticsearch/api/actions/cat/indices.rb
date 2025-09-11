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
    module Cat
      module Actions
        # Get index information.
        # Get high-level information about indices in a cluster, including backing indices for data streams.
        # Use this request to get the following information for each index in a cluster:
        # - shard count
        # - document count
        # - deleted document count
        # - primary store size
        # - total store size of all shards, including shard replicas
        # These metrics are retrieved directly from Lucene, which Elasticsearch uses internally to power indexing and search. As a result, all document counts include hidden nested documents.
        # To get an accurate count of Elasticsearch documents, use the cat count or count APIs.
        # CAT APIs are only intended for human consumption using the command line or Kibana console.
        # They are not intended for use by applications. For application consumption, use an index endpoint.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases used to limit the request.
        #  Supports wildcards (`*`). To target all data streams and indices, omit this parameter or use `*` or `_all`.
        # @option arguments [String] :bytes The unit used to display byte values.
        # @option arguments [String, Array<String>] :expand_wildcards The type of index that wildcard patterns can match.
        # @option arguments [String] :health The health status used to limit returned indices. By default, the response includes indices of any health status.
        # @option arguments [Boolean] :include_unloaded_segments If true, the response includes information from segments that are not loaded into memory.
        # @option arguments [Boolean] :pri If true, the response only includes information from primary shards.
        # @option arguments [String] :time The unit used to display time values.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [String, Array<String>] :h A comma-separated list of columns names to display. It supports simple wildcards.
        # @option arguments [String, Array<String>] :s List of columns that determine how the table should be sorted.
        #  Sorting defaults to ascending and can be changed by setting `:asc`
        #  or `:desc` as a suffix to the column name.
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  `text`, `json`, `cbor`, `yaml`, or `smile`. Server default: text.
        # @option arguments [Boolean] :help When set to `true` will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to `true` will enable verbose output.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"eixsts_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-cat-indices
        #
        def indices(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.indices' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "_cat/indices/#{Utils.listify(_index)}"
                   else
                     '_cat/indices'
                   end
          params = Utils.process_params(arguments)
          params[:h] = Utils.listify(params[:h]) if params[:h]

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
