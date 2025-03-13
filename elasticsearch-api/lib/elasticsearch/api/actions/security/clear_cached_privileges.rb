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
    module Security
      module Actions
        # Clear the privileges cache.
        # Evict privileges from the native application privilege cache.
        # The cache is also automatically cleared for applications that have their privileges updated.
        #
        # @option arguments [String] :application A comma-separated list of applications.
        #  To clear all applications, use an asterism (+*+).
        #  It does not support other wildcard patterns. (*Required*)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-clear-cached-privileges
        #
        def clear_cached_privileges(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.clear_cached_privileges' }

          defined_params = [:application].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'application' missing" unless arguments[:application]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _application = arguments.delete(:application)

          method = Elasticsearch::API::HTTP_POST
          path   = "_security/privilege/#{Utils.listify(_application)}/_clear_cache"
          params = {}

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
