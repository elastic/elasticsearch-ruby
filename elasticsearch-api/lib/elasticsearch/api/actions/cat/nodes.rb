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
    module Cat
      module Actions
        # Returns basic statistics about performance of cluster nodes.
        #
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :full_id Return the full node ID instead of the shortened version (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values (options: d, h, m, s, ms, micros, nanos)
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Boolean] :include_unloaded_segments If set to true segment stats will include stats for segments that are not currently loaded into memory
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/cat-nodes.html
        #
        def nodes(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.nodes' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_cat/nodes'
          params = Utils.process_params(arguments)
          params[:h] = Utils.__listify(params[:h], escape: false) if params[:h]

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
