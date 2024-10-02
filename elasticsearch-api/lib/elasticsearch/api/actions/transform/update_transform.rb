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
    module Transform
      module Actions
        # Updates certain properties of a transform.
        #
        # @option arguments [String] :transform_id The id of the transform. (*Required*)
        # @option arguments [Boolean] :defer_validation If validations should be deferred until transform starts, defaults to false.
        # @option arguments [Time] :timeout Controls the time to wait for the update
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The update transform definition (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/update-transform.html
        #
        def update_transform(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'transform.update_transform' }

          defined_params = [:transform_id].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'transform_id' missing" unless arguments[:transform_id]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_POST
          path   = "_transform/#{Utils.__listify(_transform_id)}/_update"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
