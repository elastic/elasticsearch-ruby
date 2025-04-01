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
# Auto generated from commit 69cbe7cbe9f49a2886bb419ec847cffb58f8b4fb
# @see https://github.com/elastic/elasticsearch-specification
#
module Elasticsearch
  module API
    module Cluster
      module Actions
        # Get cluster info.
        # Returns basic information about the cluster.
        #
        # @option arguments [String, Array<String>] :target Limits the information returned to the specific target. Supports a comma-separated list, such as http,ingest. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-info
        #
        def info(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.info' }

          defined_params = [:target].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'target' missing" unless arguments[:target]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _target = arguments.delete(:target)

          method = Elasticsearch::API::HTTP_GET
          path   = "_info/#{Utils.listify(_target)}"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
