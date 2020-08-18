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
    module Actions
      # Creates or updates a script.
      #
      # @option arguments [String] :id Script ID
      # @option arguments [String] :context Script context
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Time] :master_timeout Specify timeout for connection to master
      # @option arguments [String] :context Context name to compile script against
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The document (*Required*)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.9/modules-scripting.html
      #
      def put_script(arguments = {})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        _id = arguments.delete(:id)

        _context = arguments.delete(:context)

        method = Elasticsearch::API::HTTP_PUT
        path   = if _id && _context
                   "_scripts/#{Utils.__listify(_id)}/#{Utils.__listify(_context)}"
                 else
                   "_scripts/#{Utils.__listify(_id)}"
                 end
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = arguments[:body]
        perform_request(method, path, params, body, headers).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:put_script, [
        :timeout,
        :master_timeout,
        :context
      ].freeze)
    end
  end
end
