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
        # Update index settings.
        # Changes dynamic index settings in real time.
        # For data streams, index setting changes are applied to all backing indices by default.
        # To revert a setting to the default value, use a null value.
        # The list of per-index settings that can be updated dynamically on live indices can be found in index settings documentation.
        # To preserve existing settings from being updated, set the `preserve_existing` parameter to `true`.
        # For performance optimization during bulk indexing, you can disable the refresh interval.
        # Refer to {https://www.elastic.co/docs/deploy-manage/production-guidance/optimize-performance/indexing-speed#disable-refresh-interval disable refresh interval} for an example.
        # There are multiple valid ways to represent index settings in the request body. You can specify only the setting, for example:
        #
        # ```
        # {
        #   "number_of_replicas": 1
        # }
        # ```
        #
        # Or you can use an `index` setting object:
        #
        # ```
        # {
        #   "index": {
        #     "number_of_replicas": 1
        #   }
        # }
        # ```
        #
        # Or you can use dot annotation:
        #
        # ```
        # {
        #   "index.number_of_replicas": 1
        # }
        # ```
        #
        # Or you can embed any of the aforementioned options in a `settings` object. For example:
        #
        # ```
        # {
        #   "settings": {
        #     "index": {
        #       "number_of_replicas": 1
        #     }
        #   }
        # }
        # ```
        #
        # NOTE: You can only define new analyzers on closed indices.
        # To add an analyzer, you must close the index, define the analyzer, and reopen the index.
        # You cannot close the write index of a data stream.
        # To update the analyzer for a data stream's write index and future backing indices, update the analyzer in the index template used by the stream.
        # Then roll over the data stream to apply the new analyzer to the stream's write index and future backing indices.
        # This affects searches and any new data added to the stream after the rollover.
        # However, it does not affect the data stream's backing indices or their existing data.
        # To change the analyzer for existing backing indices, you must create a new data stream and reindex your data into it.
        # Refer to {https://www.elastic.co/docs/manage-data/data-store/text-analysis/specify-an-analyzer#update-analyzers-on-existing-indices updating analyzers on existing indices} for step-by-step examples.
        #
        # @option arguments [String, Array] :index Comma-separated list of data streams, indices, and aliases used to limit
        #  the request. Supports wildcards (`*`). To target all data streams and
        #  indices, omit this parameter or use `*` or `_all`.
        # @option arguments [Boolean] :allow_no_indices If `false`, the request returns an error if any wildcard expression, index
        #  alias, or `_all` value targets only missing or closed indices. This
        #  behavior applies even if the request targets other open indices. For
        #  example, a request targeting `foo*,bar*` returns an error if an index
        #  starts with `foo` but no index starts with `bar`.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match. If the request can target
        #  data streams, this argument determines whether wildcard expressions match
        #  hidden data streams. Supports comma-separated values, such as
        #  `open,hidden`. Server default: open.
        # @option arguments [Boolean] :flat_settings If `true`, returns settings in flat format.
        # @option arguments [Boolean] :ignore_unavailable If `true`, returns settings in flat format.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is
        #  received before the timeout expires, the request fails and returns an
        #  error. Server default: 30s.
        # @option arguments [Boolean] :preserve_existing If `true`, existing index settings remain unchanged.
        # @option arguments [Boolean] :reopen Whether to close and reopen the index to apply non-dynamic settings.
        #  If set to `true` the indices to which the settings are being applied
        #  will be closed temporarily and then reopened in order to apply the changes.
        # @option arguments [Time] :timeout Period to wait for a response. If no response is received before the
        #   timeout expires, the request fails and returns an error. Server default: 30s.
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
        # @option arguments [Hash] :body settings
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-put-settings
        #
        def put_settings(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.put_settings' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_PUT
          path   = if _index
                     "#{Utils.listify(_index)}/_settings"
                   else
                     '_settings'
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
