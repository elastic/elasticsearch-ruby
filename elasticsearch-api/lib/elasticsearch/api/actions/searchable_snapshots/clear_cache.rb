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
# Auto generated from commit 3e97c19ea994ba17fbdaa94e813b27c345f9bbbd
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module SearchableSnapshots
      module Actions
        # Clear the cache.
        # Clear indices and data streams from the shared cache for partially mounted indices.
        # This functionality is Experimental and may be changed or removed
        # completely in a future release. Elastic will take a best effort approach
        # to fix any issues, but experimental features are not subject to the
        # support SLA of official GA features.
        #
        # @option arguments [String, Array] :index A comma-separated list of data streams, indices, and aliases to clear from the cache.
        #  It supports wildcards (+*+).
        # @option arguments [String, Array<String>] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both.
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes +_all+ string or when no indices have been specified)
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-searchable-snapshots-clear-cache
        #
        def clear_cache(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'searchable_snapshots.clear_cache' }

          defined_params = [:index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _index
                     "#{Utils.listify(_index)}/_searchable_snapshots/cache/clear"
                   else
                     '_searchable_snapshots/cache/clear'
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
