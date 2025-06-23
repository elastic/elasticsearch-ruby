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
# This code was automatically generated from the Elasticsearch Specification
# See https://github.com/elastic/elasticsearch-specification
# See Elasticsearch::ES_SPECIFICATION_COMMIT for commit hash.
module Elasticsearch
  module API
    module Security
      module Actions
        # Create a service account token.
        # Create a service accounts token for access without requiring basic authentication.
        # NOTE: Service account tokens never expire.
        # You must actively delete them if they are no longer needed.
        #
        # @option arguments [String] :namespace The name of the namespace, which is a top-level grouping of service accounts. (*Required*)
        # @option arguments [String] :service The name of the service. (*Required*)
        # @option arguments [String] :name The name for the service account token.
        #  If omitted, a random name will be generated.Token names must be at least one and no more than 256 characters.
        #  They can contain alphanumeric characters (a-z, A-Z, 0-9), dashes (`-`), and underscores (`_`), but cannot begin with an underscore.NOTE: Token names must be unique in the context of the associated service account.
        #  They must also be globally unique with their fully qualified names, which are comprised of the service account principal and token name, such as `<namespace>/<service>/<token-name>`.
        # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` (the default) then wait for a refresh to make this operation visible to search, if `false` then do nothing with refreshes.
        # @option arguments [Boolean] :error_trace When set to `true` Elasticsearch will include the full stack trace of errors
        #  when they occur.
        # @option arguments [String, Array<String>] :filter_path Comma-separated list of filters in dot notation which reduce the response
        #  returned by Elasticsearch.
        # @option arguments [Boolean] :human When set to `true` will return statistics in a format suitable for humans.
        #  For example `"exists_time": "1h"` for humans and
        #  `"exists_time_in_millis": 3600000` for computers. When disabled the human
        #  readable values will be omitted. This makes sense for responses being consumed
        #  only by machines.
        # @option arguments [Boolean] :pretty If set to `true` the returned JSON will be "pretty-formatted". Only use
        #  this option for debugging only.
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-security-create-service-token
        #
        def create_service_token(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'security.create_service_token' }

          defined_params = [:namespace, :service, :name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'namespace' missing" unless arguments[:namespace]
          raise ArgumentError, "Required argument 'service' missing" unless arguments[:service]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = nil

          _namespace = arguments.delete(:namespace)

          _service = arguments.delete(:service)

          _name = arguments.delete(:name)

          method = _name ? Elasticsearch::API::HTTP_PUT : Elasticsearch::API::HTTP_POST
          path   = if _namespace && _service && _name
                     "_security/service/#{Utils.listify(_namespace)}/#{Utils.listify(_service)}/credential/token/#{Utils.listify(_name)}"
                   else
                     "_security/service/#{Utils.listify(_namespace)}/#{Utils.listify(_service)}/credential/token"
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
