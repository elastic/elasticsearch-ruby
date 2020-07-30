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
      module Rollup
        module Actions
          # Enables searching rolled-up data using the standard query DSL.
          # This functionality is Experimental and may be changed or removed
          # completely in a future release. Elastic will take a best effort approach
          # to fix any issues, but experimental features are not subject to the
          # support SLA of official GA features.
          #
          # @option arguments [List] :index The indices or index-pattern(s) (containing rollup or regular data) that should be searched
          # @option arguments [String] :type The doc type inside the index   *Deprecated*
          # @option arguments [Boolean] :typed_keys Specify whether aggregation and suggester names should be prefixed by their respective types in the response
          # @option arguments [Boolean] :rest_total_hits_as_int Indicates whether hits.total should be rendered as an integer or an object in the rest search response
          # @option arguments [Hash] :headers Custom HTTP headers
          # @option arguments [Hash] :body The search request body (*Required*)
          #
          # *Deprecation notice*:
          # Specifying types in urls has been deprecated
          # Deprecated since version 7.0.0
          #
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.8/rollup-search.html
          #
          def rollup_search(arguments = {})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _index = arguments.delete(:index)

            _type = arguments.delete(:type)

            method = Elasticsearch::API::HTTP_GET
            path   = if _index && _type
                       "#{Elasticsearch::API::Utils.__listify(_index)}/#{Elasticsearch::API::Utils.__listify(_type)}/_rollup_search"
                     else
                       "#{Elasticsearch::API::Utils.__listify(_index)}/_rollup_search"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = arguments[:body]
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:rollup_search, [
            :typed_keys,
            :rest_total_hits_as_int
          ].freeze)
      end
    end
    end
  end
end
