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
    module Actions
      # Creates or updates a script.
      #
      # @option arguments [String] :id Script ID
      # @option arguments [String] :context Script context
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Time] :master_timeout Specify timeout for connection to master
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The document (*Required*)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.16/modules-scripting.html
      #
      def put_script(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'put_script' }

        defined_params = %i[id context].each_with_object({}) do |variable, set_variables|
          set_variables[variable] = arguments[variable] if arguments.key?(variable)
        end
        request_opts[:defined_params] = defined_params unless defined_params.empty?

        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        arguments = arguments.clone
        headers = arguments.delete(:headers) || {}

        body = arguments.delete(:body)

        _id = arguments.delete(:id)

        _context = arguments.delete(:context)

        method = Elasticsearch::API::HTTP_PUT
        path   = if _id && _context
                   "_scripts/#{Utils.__listify(_id)}/#{Utils.__listify(_context)}"
                 else
                   "_scripts/#{Utils.__listify(_id)}"
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
