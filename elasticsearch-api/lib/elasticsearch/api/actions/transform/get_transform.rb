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
        # Retrieves configuration information for transforms.
        #
        # @option arguments [String] :transform_id The id or comma delimited list of id expressions of the transforms to get, '_all' or '*' implies get all transforms
        # @option arguments [Integer] :from skips a number of transform configs, defaults to 0
        # @option arguments [Integer] :size specifies a max number of transforms to get, defaults to 100
        # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no transforms. (This includes `_all` string or when no transforms have been specified)
        # @option arguments [Boolean] :exclude_generated Omits fields that are illegal to set on transform PUT
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/get-transform.html
        #
        def get_transform(arguments = {})
          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _transform_id = arguments.delete(:transform_id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _transform_id
                     "_transform/#{Utils.__listify(_transform_id)}"
                   else
                     "_transform"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
