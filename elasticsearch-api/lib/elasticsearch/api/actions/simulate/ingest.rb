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
    module Simulate
      module Actions
        # Simulate data ingestion.
        # Run ingest pipelines against a set of provided documents, optionally with substitute pipeline definitions, to simulate ingesting data into an index.
        # This API is meant to be used for troubleshooting or pipeline development, as it does not actually index any data into Elasticsearch.
        # The API runs the default and final pipeline for that index against a set of documents provided in the body of the request.
        # If a pipeline contains a reroute processor, it follows that reroute processor to the new index, running that index's pipelines as well the same way that a non-simulated ingest would.
        # No data is indexed into Elasticsearch.
        # Instead, the transformed document is returned, along with the list of pipelines that have been run and the name of the index where the document would have been indexed if this were not a simulation.
        # The transformed document is validated against the mappings that would apply to this index, and any validation error is reported in the result.
        # This API differs from the simulate pipeline API in that you specify a single pipeline for that API, and it runs only that one pipeline.
        # The simulate pipeline API is more useful for developing a single pipeline, while the simulate ingest API is more useful for troubleshooting the interaction of the various pipelines that get applied when ingesting into an index.
        # By default, the pipeline definitions that are currently in the system are used.
        # However, you can supply substitute pipeline definitions in the body of the request.
        # These will be used in place of the pipeline definitions that are already in the system. This can be used to replace existing pipeline definitions or to create new ones. The pipeline substitutions are used only within this request.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :index The index to simulate ingesting into.
        #  This value can be overridden by specifying an index on each document.
        #  If you specify this parameter in the request path, it is used for any documents that do not explicitly specify an index argument.
        # @option arguments [String] :pipeline The pipeline to use as the default pipeline.
        #  This value can be used to override the default pipeline of the index.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-simulate-ingest
        #
        def ingest(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'simulate.ingest' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _index
                     "_ingest/#{Utils.listify(_index)}/_simulate"
                   else
                     '_ingest/_simulate'
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
