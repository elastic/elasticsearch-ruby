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
        # Get snapshot repository information.
        # Get a list of snapshot repositories for a cluster.
        # IMPORTANT: cat APIs are only intended for human consumption using the command line or Kibana console. They are not intended for use by applications. For application consumption, use the get snapshot repository API.
        #
        # @option arguments [String, Array<String>] :h List of columns to appear in the response. Supports simple wildcards.
        # @option arguments [String, Array<String>] :s List of columns that determine how the table should be sorted.
        #  Sorting defaults to ascending and can be changed by setting `:asc`
        #  or `:desc` as a suffix to the column name.
        # @option arguments [Boolean] :local If `true`, the request computes the list of selected nodes from the
        #  local cluster state. If `false` the list of selected nodes are computed
        #  from the cluster state of the master node. In both cases the coordinating
        #  node will send requests for further information to each selected node.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
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
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-repositories
        #
        def repositories(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.repositories' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_cat/repositories'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
