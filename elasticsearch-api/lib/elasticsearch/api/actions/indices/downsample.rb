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
    module Indices
      module Actions
        # Downsample an index.
        # Downsamples a time series (TSDS) index and reduces its size by keeping the last value or by pre-aggregating metrics:
        # - When running in `aggregate` mode, it pre-calculates and stores statistical summaries (`min`, `max`, `sum`, `value_count` and `avg`)
        # for each metric field grouped by a configured time interval and their dimensions.
        # - When running in `last_value` mode, it keeps the last value for each metric in the configured interval and their dimensions.
        # For example, a TSDS index that contains metrics sampled every 10 seconds can be downsampled to an hourly index.
        # All documents within an hour interval are summarized and stored as a single document in the downsample index.
        # NOTE: Only indices in a time series data stream are supported.
        # Neither field nor document level security can be defined on the source index.
        # The source index must be read-only (`index.blocks.write: true`).
        # This functionality is in technical preview and may be changed or removed in a future
        # release. Elastic will apply best effort to fix any issues, but features in technical
        # preview are not subject to the support SLA of official GA features.
        #
        # @option arguments [String] :index Name of the time series index to downsample. (*Required*)
        # @option arguments [String] :target_index Name of the index to create. (*Required*)
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
        # @option arguments [Hash] :body config
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-indices-downsample
        #
        def downsample(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.downsample' }

          defined_params = [:index, :target_index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'target_index' missing" unless arguments[:target_index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          _target_index = arguments.delete(:target_index)

          method = Elasticsearch::API::HTTP_POST
          path   = "#{Utils.listify(_index)}/_downsample/#{Utils.listify(_target_index)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
