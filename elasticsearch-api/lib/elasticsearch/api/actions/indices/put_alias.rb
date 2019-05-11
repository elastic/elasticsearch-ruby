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
    module Indices
      module Actions

        # Create or update a single index alias.
        #
        # @example Create an alias for current month
        #
        #     client.indices.put_alias index: 'logs-2013-06', name: 'current-month'
        #
        # @example Create an alias for multiple indices
        #
        #     client.indices.put_alias index: 'logs-2013-06', name: 'year-2013'
        #     client.indices.put_alias index: 'logs-2013-05', name: 'year-2013'
        #
        # See the {Indices::Actions#update_aliases} for performing operations with index aliases in bulk.
        #
        # @option arguments [List] :index A comma-separated list of index names the alias should point to (supports wildcards); use `_all` to perform the operation on all indices. (*Required*)
        # @option arguments [String] :name The name of the alias to be created or updated (*Required*)
        # @option arguments [Hash] :body The settings for the alias, such as `routing` or `filter`
        # @option arguments [Time] :timeout Explicit timestamp for the document
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see https://www.elastic.co/guide/reference/api/admin-indices-aliases/
        #
        def put_alias(arguments={})
          raise ArgumentError, "Required argument 'index' missing"  unless arguments[:index]
          raise ArgumentError, "Required argument 'name' missing"  unless arguments[:name]
          method = HTTP_PUT
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_alias', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.1.1
        ParamsRegistry.register(:put_alias, [
            :timeout,
            :master_timeout ].freeze)
      end
    end
  end
end
