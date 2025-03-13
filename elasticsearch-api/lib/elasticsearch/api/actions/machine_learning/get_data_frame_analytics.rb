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
        # Get data frame analytics job configuration info.
        # You can get information for multiple data frame analytics jobs in a single
        # API request by using a comma-separated list of data frame analytics jobs or a
        # wildcard expression.
        #
        # @option arguments [String] :id Identifier for the data frame analytics job. If you do not specify this
        #  option, the API returns information for the first hundred data frame
        #  analytics jobs.
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request:
        #  - Contains wildcard expressions and there are no data frame analytics
        #  jobs that match.
        #  - Contains the +_all+ string or no identifiers and there are no matches.
        #  - Contains wildcard expressions and there are only partial matches.
        #  The default value returns an empty data_frame_analytics array when there
        #  are no matches and the subset of results when there are partial matches.
        #  If this parameter is +false+, the request returns a 404 status code when
        #  there are no matches or only partial matches. Server default: true.
        # @option arguments [Integer] :from Skips the specified number of data frame analytics jobs. Server default: 0.
        # @option arguments [Integer] :size Specifies the maximum number of data frame analytics jobs to obtain. Server default: 100.
        # @option arguments [Boolean] :exclude_generated Indicates if certain fields should be removed from the configuration on
        #  retrieval. This allows the configuration to be in an acceptable format to
        #  be retrieved and then added to another cluster.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-get-data-frame-analytics
        #
        def get_data_frame_analytics(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_data_frame_analytics' }

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
                     "_ml/data_frame/analytics/#{Utils.listify(_id)}"
                   else
                     '_ml/data_frame/analytics'
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
