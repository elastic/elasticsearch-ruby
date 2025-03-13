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
    module Cat
      module Actions
        # Get the cluster health status.
        # IMPORTANT: CAT APIs are only intended for human consumption using the command line or Kibana console.
        # They are not intended for use by applications. For application consumption, use the cluster health API.
        # This API is often used to check malfunctioning clusters.
        # To help you track cluster health alongside log files and alerting systems, the API returns timestamps in two formats:
        # +HH:MM:SS+, which is human-readable but includes no date information;
        # +Unix epoch time+, which is machine-sortable and includes date information.
        # The latter format is useful for cluster recoveries that take multiple days.
        # You can use the cat health API to verify cluster health across multiple nodes.
        # You also can use the API to track the recovery of a large cluster over a longer period of time.
        #
        # @option arguments [String] :time The unit used to display time values.
        # @option arguments [Boolean] :ts If true, returns +HH:MM:SS+ and Unix epoch timestamps. Server default: true.
        # @option arguments [String, Array<String>] :h List of columns to appear in the response. Supports simple wildcards.
        # @option arguments [String, Array<String>] :s List of columns that determine how the table should be sorted.
        #  Sorting defaults to ascending and can be changed by setting +:asc+
        #  or +:desc+ as a suffix to the column name.
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  +text+, +json+, +cbor+, +yaml+, or +smile+. Server default: text.
        # @option arguments [Boolean] :help When set to +true+ will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to +true+ will enable verbose output.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cat-health
        #
        def health(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.health' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_cat/health'
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
