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
    module Actions
      # Create or update a script or search template.
      # Creates or updates a stored script or search template.
      #
      # @option arguments [String] :id The identifier for the stored script or search template.
      #  It must be unique within the cluster. (*Required*)
      # @option arguments [String] :context The context in which the script or search template should run.
      #  To prevent errors, the API immediately compiles the script or template in this context.
      # @option arguments [Time] :master_timeout The period to wait for a connection to the master node.
      #  If no response is received before the timeout expires, the request fails and returns an error.
      #  It can also be set to +-1+ to indicate that the request should never timeout. Server default: 30s.
      # @option arguments [Time] :timeout The period to wait for a response.
      #  If no response is received before the timeout expires, the request fails and returns an error.
      #  It can also be set to +-1+ to indicate that the request should never timeout. Server default: 30s.
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body request body
      #
      # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-put-script
      #
      def put_script(arguments = {})
        request_opts = { endpoint: arguments[:endpoint] || 'put_script' }

        defined_params = [:id, :context].each_with_object({}) do |variable, set_variables|
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
                   "_scripts/#{Utils.listify(_id)}/#{Utils.listify(_context)}"
                 else
                   "_scripts/#{Utils.listify(_id)}"
                 end
        params = Utils.process_params(arguments)

        Elasticsearch::API::Response.new(
          perform_request(method, path, params, body, headers, request_opts)
        )
      end
    end
  end
end
