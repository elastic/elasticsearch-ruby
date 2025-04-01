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
# Auto generated from commit 69cbe7cbe9f49a2886bb419ec847cffb58f8b4fb
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Graph
      module Actions
        # Explore graph analytics.
        # Extract and summarize information about the documents and terms in an Elasticsearch data stream or index.
        # The easiest way to understand the behavior of this API is to use the Graph UI to explore connections.
        # An initial request to the +_explore+ API contains a seed query that identifies the documents of interest and specifies the fields that define the vertices and connections you want to include in the graph.
        # Subsequent requests enable you to spider out from one more vertices of interest.
        # You can exclude vertices that have already been returned.
        #
        # @option arguments [String, Array] :index Name of the index. (*Required*)
        # @option arguments [String] :routing Custom value used to route operations to a specific shard.
        # @option arguments [Time] :timeout Specifies the period of time to wait for a response from each shard.
        #  If no response is received before the timeout expires, the request fails and returns an error.
        #  Defaults to no timeout.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/group/endpoint-graph
        #
        def explore(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'graph.explore' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = if body
                     Elasticsearch::API::HTTP_POST
                   else
                     Elasticsearch::API::HTTP_GET
                   end

          path   = "#{Utils.listify(_index)}/_graph/explore"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
