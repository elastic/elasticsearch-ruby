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
    module Cluster
      module Actions
        # Create or update a component template.
        # Component templates are building blocks for constructing index templates that specify index mappings, settings, and aliases.
        # An index template can be composed of multiple component templates.
        # To use a component template, specify it in an index template’s +composed_of+ list.
        # Component templates are only applied to new data streams and indices as part of a matching index template.
        # Settings and mappings specified directly in the index template or the create index request override any settings or mappings specified in a component template.
        # Component templates are only used during index creation.
        # For data streams, this includes data stream creation and the creation of a stream’s backing indices.
        # Changes to component templates do not affect existing indices, including a stream’s backing indices.
        # You can use C-style +/* *\/+ block comments in component templates.
        # You can include comments anywhere in the request body except before the opening curly bracket.
        # **Applying component templates**
        # You cannot directly apply a component template to a data stream or index.
        # To be applied, a component template must be included in an index template's +composed_of+ list.
        #
        # @option arguments [String] :name Name of the component template to create.
        #  Elasticsearch includes the following built-in component templates: +logs-mappings+; +logs-settings+; +metrics-mappings+; +metrics-settings+;+synthetics-mapping+; +synthetics-settings+.
        #  Elastic Agent uses these templates to configure backing indices for its data streams.
        #  If you use Elastic Agent and want to overwrite one of these templates, set the +version+ for your replacement template higher than the current version.
        #  If you don’t use Elastic Agent and want to disable all built-in component and index templates, set +stack.templates.enabled+ to +false+ using the cluster update settings API. (*Required*)
        # @option arguments [Boolean] :create If +true+, this request cannot replace or update existing component templates.
        # @option arguments [Time] :master_timeout Period to wait for a connection to the master node.
        #  If no response is received before the timeout expires, the request fails and returns an error. Server default: 30s.
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body request body
        #
        # @see https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-put-component-template
        #
        def put_component_template(arguments = {})
          request_opts = { endpoint: arguments[:endpoint] || 'cluster.put_component_template' }

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
          path   = "_component_template/#{Utils.listify(_name)}"
          params = Utils.process_params(arguments)

          Elasticsearch::API::Response.new(
            perform_request(method, path, params, body, headers, request_opts)
          )
        end
      end
    end
  end
end
