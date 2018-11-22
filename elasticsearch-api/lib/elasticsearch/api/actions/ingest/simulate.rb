# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

module Elasticsearch
  module API
    module Ingest
      module Actions

        # Execute a specific pipeline against the set of documents provided in the body of the request
        #
        # @option arguments [String] :id Pipeline ID
        # @option arguments [Hash] :body The pipeline definition (*Required*)
        # @option arguments [Boolean] :verbose Verbose mode. Display data output for each processor
        #                                                    in executed pipeline
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/simulate-pipeline-api.html
        #
        def simulate(arguments={})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = 'GET'
          path   = Utils.__pathify "_ingest/pipeline", Utils.__escape(arguments[:id]), '_simulate'
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:simulate, [ :verbose ].freeze)
      end
    end
  end
end
