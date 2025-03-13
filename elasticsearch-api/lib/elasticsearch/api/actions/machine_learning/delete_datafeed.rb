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
        # Delete a datafeed.
        #
        # @option arguments [String] :datafeed_id A numerical character string that uniquely identifies the datafeed. This
        #  identifier can contain lowercase alphanumeric characters (a-z and 0-9),
        #  hyphens, and underscores. It must start and end with alphanumeric
        #  characters. (*Required*)
        # @option arguments [Boolean] :force Use to forcefully delete a started datafeed; this method is quicker than
        #  stopping and deleting the datafeed.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ml-delete-datafeed
        #
        def delete_datafeed(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'ml.delete_datafeed' }

          defined_params = [:datafeed_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'datafeed_id' missing" unless arguments[:datafeed_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _datafeed_id = arguments.delete(:datafeed_id)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_ml/datafeeds/#{Utils.listify(_datafeed_id)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
