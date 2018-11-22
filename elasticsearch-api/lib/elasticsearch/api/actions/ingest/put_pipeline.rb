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

        # Add or update a specified pipeline
        #
        # @option arguments [String] :id Pipeline ID (*Required*)
        # @option arguments [Hash] :body The ingest definition (*Required*)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/plugins/master/ingest.html
        #
        def put_pipeline(arguments={})
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = 'PUT'
          path   = Utils.__pathify "_ingest/pipeline", Utils.__escape(arguments[:id])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:put_pipeline, [
            :master_timeout,
            :timeout ].freeze)
      end
    end
  end
end
