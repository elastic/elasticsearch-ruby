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
    module Actions
      # Allows to use the Mustache language to pre-render a search definition.
      #
      # @option arguments [String] :id The id of the stored search template
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The search definition template and its params
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/render-search-template-api.html
      #
      def render_search_template(arguments = {})
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
                   "_render/template/#{Utils.__listify(_id)}"
                 else
                   "_render/template"
                 end
        params = {}

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers)
        )
      end
    end
  end
end
