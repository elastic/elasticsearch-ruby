# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions
        # Returns mapping for one or more fields.
        #
        # @option arguments [List] :fields A comma-separated list of fields
        # @option arguments [List] :index A comma-separated list of index names
        # @option arguments [Boolean] :include_defaults Whether the default mapping values should be returned as well
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both.
        #   (options: open,closed,hidden,none,all)

        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/indices-get-field-mapping.html
        #
        def get_field_mapping(arguments = {})
          _fields = arguments.delete(:field) || arguments.delete(:fields)
          raise ArgumentError, "Required argument 'field' missing" unless _fields

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index && _fields
                     "#{Utils.__listify(_index)}/_mapping/field/#{Utils.__listify(_fields)}"
                   else
                     "_mapping/field/#{Utils.__listify(_fields)}"
      end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get_field_mapping, [
          :include_defaults,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards,
          :local
        ].freeze)
end
      end
  end
end
