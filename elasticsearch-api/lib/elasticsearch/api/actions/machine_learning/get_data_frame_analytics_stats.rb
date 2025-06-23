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
    module MachineLearning
      module Actions
        # Get data frame analytics job stats.
        #
        # @option arguments [String] :id Identifier for the data frame analytics job. If you do not specify this
        #  option, the API returns information for the first hundred data frame
        #  analytics jobs.
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request:
        #  - Contains wildcard expressions and there are no data frame analytics
        #  jobs that match.
        #  - Contains the `_all` string or no identifiers and there are no matches.
        #  - Contains wildcard expressions and there are only partial matches.
        #  The default value returns an empty data_frame_analytics array when there
        #  are no matches and the subset of results when there are partial matches.
        #  If this parameter is `false`, the request returns a 404 status code when
        #  there are no matches or only partial matches. Server default: true.
        # @option arguments [Integer] :from Skips the specified number of data frame analytics jobs. Server default: 0.
        # @option arguments [Integer] :size Specifies the maximum number of data frame analytics jobs to obtain. Server default: 100.
        # @option arguments [Boolean] :verbose Defines whether the stats response should be verbose.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-data-frame-analytics-stats
        #
        def get_data_frame_analytics_stats(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_data_frame_analytics_stats' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _id
                     "_ml/data_frame/analytics/#{Utils.listify(_id)}/_stats"
                   else
                     '_ml/data_frame/analytics/_stats'
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
