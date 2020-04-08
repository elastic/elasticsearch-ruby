# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cluster
      module Actions
        # Returns information about whether a particular component template exist
        #
        # @option arguments [String] :name The name of the template
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/indices-component-templates.html
        #
        def exists_component_template(arguments = {})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_HEAD
          path   = "_component_template/#{Utils.__listify(_name)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        alias_method :exists_component_template?, :exists_component_template
        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:exists_component_template, [
          :master_timeout,
          :local
        ].freeze)
end
      end
  end
end
