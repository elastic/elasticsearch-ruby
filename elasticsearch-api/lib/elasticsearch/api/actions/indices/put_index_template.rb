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
        # Create or update an index template.
        # Index templates define settings, mappings, and aliases that can be applied automatically to new indices.
        # Elasticsearch applies templates to new indices based on an wildcard pattern that matches the index name.
        # Index templates are applied during data stream or index creation.
        # For data streams, these settings and mappings are applied when the stream's backing indices are created.
        # Settings and mappings specified in a create index API request override any settings or mappings specified in an index template.
        # Changes to index templates do not affect existing indices, including the existing backing indices of a data stream.
        # You can use C-style +/* *\/+ block comments in index templates.
        # You can include comments anywhere in the request body, except before the opening curly bracket.
        # **Multiple matching templates**
        # If multiple index templates match the name of a new index or data stream, the template with the highest priority is used.
        # Multiple templates with overlapping index patterns at the same priority are not allowed and an error will be thrown when attempting to create a template matching an existing index template at identical priorities.
        # **Composing aliases, mappings, and settings**
        # When multiple component templates are specified in the +composed_of+ field for an index template, they are merged in the order specified, meaning that later component templates override earlier component templates.
        # Any mappings, settings, or aliases from the parent index template are merged in next.
        # Finally, any configuration on the index request itself is merged.
        # Mapping definitions are merged recursively, which means that later mapping components can introduce new field mappings and update the mapping configuration.
        # If a field mapping is already contained in an earlier component, its definition will be completely overwritten by the later one.
        # This recursive merging strategy applies not only to field mappings, but also root options like +dynamic_templates+ and +meta+.
        # If an earlier component contains a +dynamic_templates+ block, then by default new +dynamic_templates+ entries are appended onto the end.
        # If an entry already exists with the same key, then it is overwritten by the new definition.
        #
        # @option arguments [String] :name Index or template name (*Required*)
        # @option arguments [Boolean] :create If +true+, this request cannot replace or update existing index templates.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [String] :cause User defined reason for creating/updating the index template
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-put-index-template
        #
        def put_index_template(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'indices.put_index_template' }

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
          path   = "_index_template/#{Utils.listify(_name)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
