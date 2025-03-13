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
        # Stop datafeeds.
        # A datafeed that is stopped ceases to retrieve data from Elasticsearch. A datafeed can be started and stopped
        # multiple times throughout its lifecycle.
        #
        # @option arguments [String] :datafeed_id Identifier for the datafeed. You can stop multiple datafeeds in a single API request by using a comma-separated
        #  list of datafeeds or a wildcard expression. You can close all datafeeds by using +_all+ or by specifying +*+ as
        #  the identifier. (*Required*)
        # @option arguments [Boolean] :allow_no_match Specifies what to do when the request:
        #  - Contains wildcard expressions and there are no datafeeds that match.
        #  - Contains the +_all+ string or no identifiers and there are no matches.
        #  - Contains wildcard expressions and there are only partial matches.
        #  If +true+, the API returns an empty datafeeds array when there are no matches and the subset of results when
        #  there are partial matches. If +false+, the API returns a 404 status code when there are no matches or only
        #  partial matches. Server default: true.
        # @option arguments [Boolean] :force If +true+, the datafeed is stopped forcefully.
        # @option arguments [Time] :timeout Specifies the amount of time to wait until a datafeed stops. Server default: 20s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-stop-datafeed
        #
        def stop_datafeed(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.stop_datafeed' }

          defined_params = [:datafeed_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _datafeed_id = arguments.delete(:datafeed_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_ml/datafeeds/#{Utils.listify(_datafeed_id)}/_stop"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
