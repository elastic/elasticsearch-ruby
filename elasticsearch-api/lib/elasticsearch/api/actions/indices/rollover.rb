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
    module Indices
      module Actions
        # Roll over to a new index.
        # TIP: It is recommended to use the index lifecycle rollover action to automate rollovers.
        # The rollover API creates a new index for a data stream or index alias.
        # The API behavior depends on the rollover target.
        # **Roll over a data stream**
        # If you roll over a data stream, the API creates a new write index for the stream.
        # The stream's previous write index becomes a regular backing index.
        # A rollover also increments the data stream's generation.
        # **Roll over an index alias with a write index**
        # TIP: Prior to Elasticsearch 7.9, you'd typically use an index alias with a write index to manage time series data.
        # Data streams replace this functionality, require less maintenance, and automatically integrate with data tiers.
        # If an index alias points to multiple indices, one of the indices must be a write index.
        # The rollover API creates a new write index for the alias with +is_write_index+ set to +true+.
        # The API also +sets is_write_index+ to +false+ for the previous write index.
        # **Roll over an index alias with one index**
        # If you roll over an index alias that points to only one index, the API creates a new index for the alias and removes the original index from the alias.
        # NOTE: A rollover creates a new index and is subject to the +wait_for_active_shards+ setting.
        # **Increment index names for an alias**
        # When you roll over an index alias, you can specify a name for the new index.
        # If you don't specify a name and the current index ends with +-+ and a number, such as +my-index-000001+ or +my-index-3+, the new index name increments that number.
        # For example, if you roll over an alias with a current index of +my-index-000001+, the rollover creates a new index named +my-index-000002+.
        # This number is always six characters and zero-padded, regardless of the previous index's name.
        # If you use an index alias for time series data, you can use date math in the index name to track the rollover date.
        # For example, you can create an alias that points to an index named +<my-index-{now/d}-000001>+.
        # If you create the index on May 6, 2099, the index's name is +my-index-2099.05.06-000001+.
        # If you roll over the alias on May 7, 2099, the new index's name is +my-index-2099.05.07-000002+.
        #
        # @option arguments [String] :alias Name of the data stream or index alias to roll over. (*Required*)
        # @option arguments [String] :new_index Name of the index to create.
        #  Supports date math.
        #  Data streams do not support this parameter.
        # @option arguments [Boolean] :dry_run If +true+, checks whether the current index satisfies the specified conditions but does not perform a rollover.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Time] :timeout Period to wait for a response.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Integer, String] :wait_for_active_shards The number of shard copies that must be active before proceeding with the operation.
        #  Set to all or any positive integer up to the total number of shards in the index (+number_of_replicas+1+). Server default: 1.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-rollover
        #
        def rollover(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.rollover' }

          defined_params = [:alias, :new_index].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'alias' missing" unless arguments[:alias]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _alias = arguments.delete(:alias)

          _new_index = arguments.delete(:new_index)

          method = Elasticsearch::API::HTTP_POST
          path   = if _alias && _new_index
                     "#{Utils.listify(_alias)}/_rollover/#{Utils.listify(_new_index)}"
                   else
                     "#{Utils.listify(_alias)}/_rollover"
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
