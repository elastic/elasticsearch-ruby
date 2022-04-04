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

module Elasticsearch
  module API
    module MachineLearning
      module Actions
        # Previews a datafeed.
        #
        # @option arguments [String] :datafeed_id The ID of the datafeed to preview
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The datafeed config and job config with which to execute the preview
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.2/ml-preview-datafeed.html
        #
        def preview_datafeed(arguments = {})
          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _datafeed_id = arguments.delete(:datafeed_id)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = if _datafeed_id
                     "_ml/datafeeds/#{Utils.__listify(_datafeed_id)}/_preview"
                   else
                     "_ml/datafeeds/_preview"
                   end
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
