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
    module Indices
      module Actions
        # Analyze the index disk usage.
        # Analyze the disk usage of each field of an index or data stream.
        # This API might not support indices created in previous Elasticsearch versions.
        # The result of a small index can be inaccurate as some parts of an index might not be analyzed by the API.
        # NOTE: The total size of fields of the analyzed shards of the index in the response is usually smaller than the index +store_size+ value because some small metadata files are ignored and some parts of data files might not be scanned by the API.
        # Since stored fields are stored together in a compressed format, the sizes of stored fields are also estimates and can be inaccurate.
        # The stored size of the +_id+ field is likely underestimated while the +_source+ field is overestimated.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases used to limit the request.
        #  It’s recommended to execute this API with a single index (or the latest backing index of a data stream) as the API consumes resources significantly. (*Required*)
        # @option arguments [Boolean] :allow_no_indices If false, the request returns an error if any wildcard expression, index alias, or +_all+ value targets only missing or closed indices.
        #  This behavior applies even if the request targets other open indices.
        #  For example, a request targeting +foo*,bar*+ returns an error if an index starts with +foo+ but no index starts with +bar+. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match.
        #  If the request can target data streams, this argument determines whether wildcard expressions match hidden data streams.
        #  Supports comma-separated values, such as +open,hidden+. Server default: open.
        # @option arguments [Boolean] :flush If +true+, the API performs a flush before analysis.
        #  If +false+, the response may not include uncommitted data. Server default: true.
        # @option arguments [Boolean] :ignore_unavailable If +true+, missing or closed indices are not included in the response.
        # @option arguments [Boolean] :run_expensive_tasks Analyzing field disk usage is resource-intensive.
        #  To use the API, this parameter must be set to +true+.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-disk-usage
        #
        def disk_usage(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.disk_usage' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.listify(_index)}/_disk_usage"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
