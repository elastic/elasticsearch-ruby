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
    module MachineLearning
      module Actions
        # Get overall bucket results.
        # Retrievs overall bucket results that summarize the bucket results of
        # multiple anomaly detection jobs.
        # The +overall_score+ is calculated by combining the scores of all the
        # buckets within the overall bucket span. First, the maximum
        # +anomaly_score+ per anomaly detection job in the overall bucket is
        # calculated. Then the +top_n+ of those scores are averaged to result in
        # the +overall_score+. This means that you can fine-tune the
        # +overall_score+ so that it is more or less sensitive to the number of
        # jobs that detect an anomaly at the same time. For example, if you set
        # +top_n+ to +1+, the +overall_score+ is the maximum bucket score in the
        # overall bucket. Alternatively, if you set +top_n+ to the number of jobs,
        # the +overall_score+ is high only when all jobs detect anomalies in that
        # overall bucket. If you set the +bucket_span+ parameter (to a value
        # greater than its default), the +overall_score+ is the maximum
        # +overall_score+ of the overall buckets that have a span equal to the
        # jobs' largest bucket span.
        #
        # @option arguments [String] :job_id Identifier for the anomaly detection job. It can be a job identifier, a
        #  group name, a comma-separated list of jobs or groups, or a wildcard
        #  expression.You can summarize the bucket results for all anomaly detection jobs by
        #  using +_all+ or by specifying +*+ as the +<job_id>+. (*Required*)
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request:
        #  - Contains wildcard expressions and there are no jobs that match.
        #  - Contains the +_all+ string or no identifiers and there are no matches.
        #  - Contains wildcard expressions and there are only partial matches.
        #  If +true+, the request returns an empty +jobs+ array when there are no
        #  matches and the subset of results when there are partial matches. If this
        #  parameter is +false+, the request returns a +404+ status code when there
        #  are no matches or only partial matches. Server default: true.
        # @option arguments [Time] :bucket_span The span of the overall buckets. Must be greater or equal to the largest
        #  bucket span of the specified anomaly detection jobs, which is the default
        #  value.By default, an overall bucket has a span equal to the largest bucket span
        #  of the specified anomaly detection jobs. To override that behavior, use
        #  the optional +bucket_span+ parameter.
        # @option arguments [String, Time] :end Returns overall buckets with timestamps earlier than this time.
        # @option arguments [Boolean] :exclude_interim If +true+, the output excludes interim results.
        # @option arguments [Double, String] :overall_score Returns overall buckets with overall scores greater than or equal to this
        #  value.
        # @option arguments [String, Time] :start Returns overall buckets with timestamps after this time.
        # @option arguments [Integer] :top_n The number of top anomaly detection job bucket scores to be used in the
        #  +overall_score+ calculation. Server default: 1.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-overall-buckets
        #
        def get_overall_buckets(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_overall_buckets' }

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

          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}/results/overall_buckets"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
