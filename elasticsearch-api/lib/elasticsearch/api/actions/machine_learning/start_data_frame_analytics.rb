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
        # Start a data frame analytics job.
        # A data frame analytics job can be started and stopped multiple times
        # throughout its lifecycle.
        # If the destination index does not exist, it is created automatically the
        # first time you start the data frame analytics job. The
        # `index.number_of_shards` and `index.number_of_replicas` settings for the
        # destination index are copied from the source index. If there are multiple
        # source indices, the destination index copies the highest setting values. The
        # mappings for the destination index are also copied from the source indices.
        # If there are any mapping conflicts, the job fails to start.
        # If the destination index exists, it is used as is. You can therefore set up
        # the destination index in advance with custom settings and mappings.
        #
        # @option arguments [String] :id Identifier for the data frame analytics job. This identifier can contain
        #  lowercase alphanumeric characters (a-z and 0-9), hyphens, and
        #  underscores. It must start and end with alphanumeric characters. (*Required*)
        # @option arguments [Time] :timeout Controls the amount of time to wait until the data frame analytics job
        #  starts. Server default: 20s.
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
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-ml-start-data-frame-analytics
        #
        def start_data_frame_analytics(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.start_data_frame_analytics' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/data_frame/analytics/#{Utils.listify(_id)}/_start"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
