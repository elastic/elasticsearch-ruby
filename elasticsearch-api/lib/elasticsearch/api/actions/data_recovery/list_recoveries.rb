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
    module DataRecovery
      module Actions
        # List recoveries.
        # List the recoveries that were started with the start recovery API, including those that have finished.
        # This API is intended for internal operator use.
        # Recoveries are ordered by start time, and the most recent are returned first by default.
        # To retrieve further pages, pass the start time and identifier of the last recovery of a page as `search_after_started_at` and `search_after_recovery_id`.
        # This functionality is subject to potential breaking changes within a
        # minor version, meaning that your referencing code may break when this
        # library is upgraded.
        #
        # @option arguments [Integer] :size The maximum number of recoveries to return. The value must be between 1 and 1000. Server default: 100.
        # @option arguments [String, Time] :started_at_gte Return only recoveries that started at or after this time, as an ISO-8601 timestamp.
        # @option arguments [String, Time] :started_at_lt Return only recoveries that started before this time, as an ISO-8601 timestamp. It must not be earlier than `started_at_gte`.
        # @option arguments [String] :order The order of the recoveries by start time. Server default: desc.
        # @option arguments [String, Time] :search_after_started_at Return only recoveries after this start time in the sort order, to retrieve the next page.
        #  It must be provided together with `search_after_recovery_id`.
        # @option arguments [String] :search_after_recovery_id Return only recoveries after this identifier in the sort order for recoveries with the same start time, to retrieve the next page.
        #  It must be provided together with `search_after_started_at`.
        # @option arguments [String, Array<String>] :status A comma-separated list of statuses. Return only recoveries with one of these statuses. By default, recoveries with any status are returned.
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
        def list_recoveries(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'data_recovery.list_recoveries' }

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          method = Elasticsearch::API::HTTP_GET
          path   = '_data_recovery/recoveries'
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
