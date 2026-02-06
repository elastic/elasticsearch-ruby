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
        # Get anomaly detection job results for influencers.
        # Influencers are the entities that have contributed to, or are to blame for,
        # the anomalies. Influencer results are available only if an
        # `influencer_field_name` is specified in the job configuration.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. (*Required*)
        # @option arguments [Boolean] :desc If true, the results are sorted in descending order.
        # @option arguments [String, Time] :end Returns influencers with timestamps earlier than this time.
        #  The default value means it is unset and results are not limited to
        #  specific timestamps. Server default: -1.
        # @option arguments [Boolean] :exclude_interim If true, the output excludes interim results. By default, interim results
        #  are included.
        # @option arguments [Float] :influencer_score Returns influencers with anomaly scores greater than or equal to this
        #  value. Server default: 0.
        # @option arguments [Integer] :from Skips the specified number of influencers. Server default: 0.
        # @option arguments [Integer] :size Specifies the maximum number of influencers to obtain. Server default: 100.
        # @option arguments [String] :sort Specifies the sort field for the requested influencers. By default, the
        #  influencers are sorted by the `influencer_score` value.
        # @option arguments [String, Time] :start Returns influencers with timestamps after this time. The default value
        #  means it is unset and results are not limited to specific timestamps. Server default: -1.
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
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/v9/operation/operation-ml-get-influencers
        #
        def get_influencers(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_influencers' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/results/influencers"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
