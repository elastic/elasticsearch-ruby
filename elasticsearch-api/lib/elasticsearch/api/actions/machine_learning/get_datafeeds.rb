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
# Auto generated from build hash f284cc16f4d4b4289bc679aa1529bb504190fe80
# @see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec
#
module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Retrieves configuration information for datafeeds.
        #
        # @option arguments [String] :datafeed_id The ID of the datafeeds to fetch
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no datafeeds. (This includes `_all` string or when no datafeeds have been specified)
        # @option arguments [Boolean] :exclude_generated Omits fields that are illegal to set on datafeed PUT
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/ml-get-datafeed.html
        #
        def get_datafeeds(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.get_datafeeds' }

          defined_params = [:datafeed_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _datafeed_id = arguments.delete(:datafeed_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _datafeed_id
                     "_ml/datafeeds/#{Utils.__listify(_datafeed_id)}"
                   else
                     '_ml/datafeeds'
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
