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
    module Indices
      module Actions
        # Get tokens from text analysis.
        # The analyze API performs analysis on a text string and returns the resulting tokens.
        # Generating excessive amount of tokens may cause a node to run out of memory.
        # The +index.analyze.max_token_count+ setting enables you to limit the number of tokens that can be produced.
        # If more than this limit of tokens gets generated, an error occurs.
        # The +_analyze+ endpoint without a specified index will always use +10000+ as its limit.
        #
        # @option arguments [String] :index Index used to derive the analyzer.
        #  If specified, the +analyzer+ or field parameter overrides this value.
        #  If no index is specified or the index does not have a default analyzer, the analyze API uses the standard analyzer.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-analyze
        #
        def analyze(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.analyze' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = if _index
                     "#{Utils.listify(_index)}/_analyze"
                   else
                     '_analyze'
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
