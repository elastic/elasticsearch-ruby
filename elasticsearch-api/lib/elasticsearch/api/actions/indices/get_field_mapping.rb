module Elasticsearch
  module API
    module Indices
      module Actions

        # Return the mapping definition for specific field (or fields)
        #
        # @example Get mapping for a specific field across all indices
        #
        #     client.indices.get_field_mapping field: 'foo'
        #
        # @example Get mapping for a specific field in an index
        #
        #     client.indices.get_field_mapping index: 'foo', field: 'bar'
        #
        # @example Get mappings for multiple fields in an index
        #
        #     client.indices.get_field_mapping index: 'foo', field: ['bar', 'bam']
        #
        # @option arguments [List] :index A comma-separated list of index names
        # @option arguments [List] :type  A comma-separated list of document types
        # @option arguments [List] :field A comma-separated list of fields (*Required*)
        # @option arguments [Boolean] :include_defaults Whether default mapping values should be returned as well
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/indices-get-field-mapping.html
        #
        def get_field_mapping(arguments={})
          raise ArgumentError, "Required argument 'field' missing" unless arguments[:field]
          valid_params = [ :include_defaults ]

          method = 'GET'
          path   = Utils.__pathify(
                     Utils.__listify(arguments[:index]),
                     Utils.__listify(arguments[:type]),
                     '_mapping', 'field',
                     Utils.__listify(arguments[:field])
                   )
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
