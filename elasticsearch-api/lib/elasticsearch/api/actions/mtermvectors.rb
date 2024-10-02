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
      # Returns multiple termvectors in one request.
      #
      # @option arguments [String] :index The index in which the document resides.
      # @option arguments [List] :ids A comma-separated list of documents ids. You must define ids as parameter or set "ids" or "docs" in the request body
      # @option arguments [Boolean] :term_statistics Specifies if total term frequency and document frequency should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :field_statistics Specifies if document count, sum of document frequencies and sum of total term frequencies should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [List] :fields A comma-separated list of fields to return. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :offsets Specifies if term offsets should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :positions Specifies if term positions should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :payloads Specifies if term payloads should be returned. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [String] :preference Specify the node or shard the operation should be performed on (default: random) .Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [String] :routing Specific routing value. Applies to all returned documents unless otherwise specified in body "params" or "docs".
      # @option arguments [Boolean] :realtime Specifies if requests are real-time as opposed to near-real-time (default: true).
      # @option arguments [Number] :version Explicit version number for concurrency control
      # @option arguments [String] :version_type Specific version type (options: internal, external, external_gte)
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body Define ids, documents, parameters or a list of parameters per document here. You must at least provide a list of document ids. See documentation.
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/docs-multi-termvectors.html
      #
      def mtermvectors(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'mtermvectors' }

        defined_params = [:index].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = if (ids = arguments.delete(:ids))
                 { ids: ids }
               else
                 arguments.delete(:body)
               end

        _index = arguments.delete(:index)

        method = if body
                   Elasticsearch::API::HTTP_POST
                 else
                   Elasticsearch::API::HTTP_GET
                 end

        path = if _index
                 "#{Utils.__listify(_index)}/_mtermvectors"
               else
                 '_mtermvectors'
               end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
