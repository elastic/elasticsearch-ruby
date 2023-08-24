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
    module Indices
      module Actions
        # Simulate resolving the given template name or body
        #
        # @option arguments [String] :name The name of the index template
        # @option arguments [Boolean] :create Whether the index template we optionally defined in the body should only be dry-run added if new or can also replace an existing one
        # @option arguments [String] :cause User defined reason for dry-run creating the new template for simulation purposes
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        # @option arguments [Boolean] :include_defaults Return all relevant default configurations for this template simulation (default: false)
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body New index template definition to be simulated, if no index template name is specified
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/8.10/indices-templates.html
        #
        def simulate_template(arguments = {})
          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_POST
          path   = if _name
                     "_index_template/_simulate/#{Utils.__listify(_name)}"
                   else
                     "_index_template/_simulate"
                   end
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers)
          )
        end
      end
    end
  end
end
