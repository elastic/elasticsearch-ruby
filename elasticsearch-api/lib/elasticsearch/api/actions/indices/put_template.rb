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
    module Indices
      module Actions
        # Creates or updates an index template.
        #
        # @option arguments [String] :name The name of the template
        # @option arguments [Boolean] :include_type_name Whether a type should be returned in the body of the mappings.
        # @option arguments [Number] :order The order for this template when merging multiple matching ones (higher numbers are merged later, overriding the lower numbers)
        # @option arguments [Boolean] :create Whether the index template should only be added if new or can also replace an existing one
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The template definition (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.17/indices-templates.html
        #
        def put_template(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_template/#{Utils.__listify(_name)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:put_template, [
          :include_type_name,
          :order,
          :create,
          :master_timeout
        ].freeze)
      end
    end
  end
end
