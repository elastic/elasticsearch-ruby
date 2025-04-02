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
# Auto generated from commit 3e97c19ea994ba17fbdaa94e813b27c345f9bbbd
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Explain data frame analytics config.
        # This API provides explanations for a data frame analytics config that either
        # exists already or one that has not been created yet. The following
        # explanations are provided:
        # * which fields are included or not in the analysis and why,
        # * how much memory is estimated to be required. The estimate can be used when deciding the appropriate value for model_memory_limit setting later on.
        # If you have object fields or fields that are excluded via source filtering, they are not included in the explanation.
        #
        # @option arguments [String] :id Identifier for the data frame analytics job. This identifier can contain
        #  lowercase alphanumeric characters (a-z and 0-9), hyphens, and
        #  underscores. It must start and end with alphanumeric characters.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-explain-data-frame-analytics
        #
        def explain_data_frame_analytics(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.explain_data_frame_analytics' }

          defined_params = [:id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _id = arguments.delete(:id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = if _id
                     "_ml/data_frame/analytics/#{Utils.listify(_id)}/_explain"
                   else
                     '_ml/data_frame/analytics/_explain'
                   end
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
