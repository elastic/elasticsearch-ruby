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
        # Get segment information.
        # Get low-level information about the Lucene segments in index shards.
        # For data streams, the API returns information about the backing indices.
        # IMPORTANT: cat APIs are only intended for human consumption using the command line or Kibana console. They are not intended for use by applications. For application consumption, use the index segments API.
        #
        # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases used to limit the request.
        #  Supports wildcards (`*`).
        #  To target all data streams and indices, omit this parameter or use `*` or `_all`.
        # @option arguments [String, Array<String>] :h A comma-separated list of columns names to display.
        #  It supports simple wildcards. Server default: ip,hp,rp,r,m,n,cpu,l.
        # @option arguments [String, Array<String>] :s A comma-separated list of column names or aliases that determines the sort order.
        #  Sorting defaults to ascending and can be changed by setting `:asc`
        #  or `:desc` as a suffix to the column name.
        # @option arguments [Boolean] :local If `true`, the request computes the list of selected nodes from the
        #  local cluster state. If `false` the list of selected nodes are computed
        #  from the cluster state of the master node. In both cases the coordinating
        #  node will send requests for further information to each selected node.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. Server default: 30s.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard expressions can match. If the request can target data streams, this argument
        #  determines whether wildcard expressions match hidden data streams. Supports comma-separated values,
        #  such as open,hidden. Server default: open.
        # @option arguments [Boolean] :allow_no_indices If false, the request returns an error if any wildcard expression, index alias, or _all value targets only
        #  missing or closed indices. This behavior applies even if the request targets other open indices. For example,
        #  a request targeting foo*,bar* returns an error if an index starts with foo but no index starts with bar. Server default: true.
        # @option arguments [Boolean] :ignore_throttled If true, concrete, expanded or aliased indices are ignored when frozen.
        # @option arguments [Boolean] :ignore_unavailable If true, missing or closed indices are not included in the response.
        # @option arguments [Boolean] :allow_closed If true, allow closed indices to be returned in the response otherwise if false, keep the legacy behaviour
        #  of throwing an exception if index pattern matches closed indices
        # @option arguments [String] :format Specifies the format to return the columnar data in, can be set to
        #  `text`, `json`, `cbor`, `yaml`, or `smile`. Server default: text.
        # @option arguments [Boolean] :help When set to `true` will output available columns. This option
        #  can't be combined with any other query string option.
        # @option arguments [Boolean] :v When set to `true` will enable verbose output.
        # @option arguments [String] :bytes Sets the units for columns that contain a byte-size value.
        #  Note that byte-size value units work in terms of powers of 1024. For instance `1kb` means 1024 bytes, not 1000 bytes.
        #  If omitted, byte-size values are rendered with a suffix such as `kb`, `mb`, or `gb`, chosen such that the numeric value of the column is as small as possible whilst still being at least `1.0`.
        #  If given, byte-size values are rendered as an integer with no suffix, representing the value of the column in the chosen unit.
        #  Values that are not an exact multiple of the chosen unit are rounded down.
        # @option arguments [String] :time Sets the units for columns that contain a time duration.
        #  If omitted, time duration values are rendered with a suffix such as `ms`, `s`, `m` or `h`, chosen such that the numeric value of the column is as small as possible whilst still being at least `1.0`.
        #  If given, time duration values are rendered as an integer with no suffix.
        #  Values that are not an exact multiple of the chosen unit are rounded down.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-cat-segments
        #
        def segments(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cat.segments' }

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
                     "_cat/segments/#{Utils.listify(_index)}"
                   else
                     '_cat/segments'
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
