# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Deletes an index template.
        #
        # @option arguments [String] :name The name of the template
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/indices-templates.html
        #
        def delete_index_template(arguments = {})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]

          arguments = arguments.clone

          _name = arguments.delete(:name)

          method = Elasticsearch::API::HTTP_DELETE
          path   = "_index_template/#{Utils.__listify(_name)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:delete_index_template, [
          :timeout,
          :master_timeout
        ].freeze)
end
      end
  end
end
