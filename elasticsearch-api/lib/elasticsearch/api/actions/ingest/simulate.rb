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
    module Ingest
      module Actions
        # Allows to simulate a pipeline with example documents.
        #
        # @option arguments [String] :id Pipeline ID
        # @option arguments [Boolean] :verbose Verbose mode. Display data output for each processor in executed pipeline
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The simulate definition (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/simulate-pipeline-api.html
        #
        def simulate(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_POST
          path   = if _id
                     "_ingest/pipeline/#{Utils.__listify(_id)}/_simulate"
                   else
                     "_ingest/pipeline/_simulate"
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
