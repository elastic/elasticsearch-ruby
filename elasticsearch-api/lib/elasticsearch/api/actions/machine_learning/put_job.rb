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
        # Create an anomaly detection job.
        # If you include a +datafeed_config+, you must have read index privileges on the source index.
        # If you include a +datafeed_config+ but do not provide a query, the datafeed uses +{"match_all": {"boost": 1}}+.
        #
        # @option arguments [String] :job_id The identifier for the anomaly detection job. This identifier can contain lowercase alphanumeric characters (a-z and 0-9), hyphens, and underscores. It must start and end with alphanumeric characters. (*Required*)
        # @option arguments [Boolean] :allow_no_indices If +true+, wildcard indices expressions that resolve into no concrete indices are ignored. This includes the
        #  +_all+ string or when no indices are specified. Server default: true.
        # @option arguments [String, Array<String>] :expand_wildcards Type of index that wildcard patterns can match. If the request can target data streams, this argument determines
        #  whether wildcard expressions match hidden data streams. Supports comma-separated values. Valid values are:
        #  - +all+: Match any data stream or index, including hidden ones.
        #  - +closed+: Match closed, non-hidden indices. Also matches any non-hidden data stream. Data streams cannot be closed.
        #  - +hidden+: Match hidden data streams and hidden indices. Must be combined with +open+, +closed+, or both.
        #  - +none+: Wildcard patterns are not accepted.
        #  - +open+: Match open, non-hidden indices. Also matches any non-hidden data stream. Server default: open.
        # @option arguments [Boolean] :ignore_throttled If +true+, concrete, expanded or aliased indices are ignored when frozen. Server default: true.
        # @option arguments [Boolean] :ignore_unavailable If +true+, unavailable indices (missing or closed) are ignored.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-put-job
        #
        def put_job(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.put_job' }

          defined_params = [:job_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'job_id' missing" unless arguments[:job_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _job_id = arguments.delete(:job_id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_ml/anomaly_detectors/#{Utils.listify(_job_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
