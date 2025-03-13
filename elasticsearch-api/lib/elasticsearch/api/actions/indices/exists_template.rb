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
        # Check existence of index templates.
        # Get information about whether index templates exist.
        # Index templates define settings, mappings, and aliases that can be applied automatically to new indices.
        # IMPORTANT: This documentation is about legacy index templates, which are deprecated and will be replaced by the composable templates introduced in Elasticsearch 7.8.
        #
        # @option arguments [String, Array<String>] :name A comma-separated list of index template names used to limit the request.
        #  Wildcard (+*+) expressions are supported. (*Required*)
        # @option arguments [Boolean] :flat_settings Indicates whether to use a flat format for the response.
        # @option arguments [Boolean] :local Indicates whether to get information from the local node only.
        # @option arguments [Time] :master_timeout The period to wait for the master node.
        #  If the master node is not available before the timeout expires, the request fails and returns an error.
        #  To indicate that the request should never timeout, set it to +-1+. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-exists-template
        #
        def exists_template(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.exists_template' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_HEAD
          path   = "_template/#{Utils.listify(_name)}"
          params = Utils.process_params(arguments)

          Utils.rescue_from_not_found do
            perform_request(method, path, params, body, headers, request_opts).status == 200
          end
        end

        alias exists_template? exists_template
      end
    end
  end
end
