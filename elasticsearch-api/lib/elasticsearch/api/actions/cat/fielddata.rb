module Elasticsearch
  module API
    module Cat
      module Actions

        # Return information about field data usage across the cluster
        #
        # @example Return the total size of field data
        #
        #     client.cat.fielddata
        #
        # @example Return both the total size and size for specific fields
        #
        #     client.cat.fielddata fields: 'title,body'
        #
        # @option arguments [List] :fields A comma-separated list of fields to return the fielddata size
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [List] :fields A comma-separated list of fields to return in the output
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-fielddata.html
        #
        def fielddata(arguments={})
          fields = arguments.delete(:fields)

          method = HTTP_GET
          path   = Utils.__pathify "_cat/fielddata", Utils.__listify(fields)
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:fielddata, [
            :format,
            :bytes,
            :local,
            :master_timeout,
            :h,
            :help,
            :s,
            :v,
            :fields ].freeze)
      end
    end
  end
end
