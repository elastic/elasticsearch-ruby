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
    module Indices
      module Actions
        # Create or update a legacy index template.
        # Index templates define settings, mappings, and aliases that can be applied automatically to new indices.
        # Elasticsearch applies templates to new indices based on an index pattern that matches the index name.
        # IMPORTANT: This documentation is about legacy index templates, which are deprecated and will be replaced by the composable templates introduced in Elasticsearch 7.8.
        # Composable templates always take precedence over legacy templates.
        # If no composable template matches a new index, matching legacy templates are applied according to their order.
        # Index templates are only applied during index creation.
        # Changes to index templates do not affect existing indices.
        # Settings and mappings specified in create index API requests override any settings or mappings specified in an index template.
        # You can use C-style `/* *\/` block comments in index templates.
        # You can include comments anywhere in the request body, except before the opening curly bracket.
        # **Indices matching multiple templates**
        # Multiple index templates can potentially match an index, in this case, both the settings and mappings are merged into the final configuration of the index.
        # The order of the merging can be controlled using the order parameter, with lower order being applied first, and higher orders overriding them.
        # NOTE: Multiple matching templates with the same order value will result in a non-deterministic merging order.
        #
        # @option arguments [String] :name The name of the template (*Required*)
        # @option arguments [Boolean] :create If true, this request cannot replace or update existing index templates.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node. If no response is
        #  received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Integer] :order Order in which Elasticsearch applies this template if index
        #  matches multiple templates.Templates with lower 'order' values are merged first. Templates with higher
        #  'order' values are merged later, overriding templates with lower values.
        # @option arguments [String] :cause User defined reason for creating or updating the index template Server default: "".
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
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-put-template
        #
        def put_template(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.put_template' }

          defined_params = [:name].each_with_object({}) do |variable, set_variables|
            set_variables[variable] = arguments[variable] if arguments.key?(variable)
          end
          request_opts[:defined_params] = defined_params unless defined_params.empty?

          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone
          headers = arguments.delete(:headers) || {}

          body = arguments.delete(:body)

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_template/#{Utils.listify(_name)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
