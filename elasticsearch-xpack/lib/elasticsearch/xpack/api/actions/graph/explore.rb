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
  module XPack
    module API
      module Graph
        module Actions
          # Explore extracted and summarized information about the documents and terms in an index.
          #
          # @option arguments [List] :index A comma-separated list of index names to search; use `_all` or empty string to perform the operation on all indices
          # @option arguments [List] :type A comma-separated list of document types to search; leave empty to perform the operation on all types   *Deprecated*
          # @option arguments [String] :routing Specific routing value
          # @option arguments [Time] :timeout Explicit operation timeout
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body Graph Query DSL
          #
          # *Deprecation notice*:
          # Specifying types in urls has been deprecated
          # Deprecated since version 7.0.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.x/graph-explore-api.html
          #
          def explore(arguments = {})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _index = arguments.delete(:index)

            _type = arguments.delete(:type)

            method = Elasticsearch::API::HTTP_GET
            path   = if _index && _type
                       "#{Elasticsearch::API::Utils.__listify(_index)}/#{Elasticsearch::API::Utils.__listify(_type)}/_graph/explore"
                     else
                       "#{Elasticsearch::API::Utils.__listify(_index)}/_graph/explore"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:explore, [
            :routing,
            :timeout
          ].freeze)
      end
    end
    end
  end
end
