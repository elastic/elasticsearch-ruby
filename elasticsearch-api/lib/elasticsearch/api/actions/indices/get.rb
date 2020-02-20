# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Returns information about one or more indices.
        #
        # @option arguments [List] :index A comma-separated list of index names
        # @option arguments [Boolean] :include_type_name Whether to add the type name to the response (default: false)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Boolean] :ignore_unavailable Ignore unavailable indexes (default: false)
        # @option arguments [Boolean] :allow_no_indices Ignore if a wildcard expression resolves to no concrete indices (default: false)
        # @option arguments [String] :expand_wildcards Whether wildcard expressions should get expanded to open or closed indices (default: open)
        #   (options: open,closed,none,all)

        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Boolean] :include_defaults Whether to return all default setting for each of the indices.
        # @option arguments [Time] :master_timeout Specify timeout for connection to master

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/indices-get-index.html
        #
        def get(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = "#{Utils.__listify(_index)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get, [
          :include_type_name,
          :local,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :flat_settings,
          :include_defaults,
          :master_timeout
        ].freeze)
end
      end
  end
end
