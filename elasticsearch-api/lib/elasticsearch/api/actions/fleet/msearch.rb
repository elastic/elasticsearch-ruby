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
    module Fleet
      module Actions
        # Multi Search API where the search will only be executed after specified checkpoints are available due to a refresh. This API is designed for internal use by the fleet server project.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String] :index The index name to use as the default
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The request definitions (metadata-fleet search request definition pairs), separated by newlines (*Required*)
        #
        # @see [TODO]
        #
        def msearch(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body   = arguments.delete(:body)

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _index
                     "#{Utils.__listify(_index)}/_fleet/_fleet_msearch"
                   else
                     "_fleet/_fleet_msearch"
                   end
          params = {}

          case
          when body.is_a?(Array) && body.any? { |d| d.has_key? :search }
            payload = body
                      .inject([]) do |sum, item|
                        meta = item
                        data = meta.delete(:search)

                        sum << meta
                        sum << data
                        sum
                      end
                      .map { |item| Elasticsearch::API.serializer.dump(item) }
            payload << "" unless payload.empty?
            payload = payload.join("\n")
          when body.is_a?(Array)
            payload = body.map { |d| d.is_a?(String) ? d : Elasticsearch::API.serializer.dump(d) }
            payload << "" unless payload.empty?
            payload = payload.join("\n")
          else
            payload = body
          end

          headers.merge!("Content-Type" => "application/x-ndjson")
          Elasticsearch::API::Response.new(
            perform_request(method, path, params, payload, headers)
          )
        end
      end
    end
  end
end
