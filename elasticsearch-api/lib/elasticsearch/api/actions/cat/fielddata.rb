module Elasticsearch
  module API
    module Cat
      module Actions

        VALID_FIELDDATA_PARAMS = [
          :bytes,
          :local,
          :master_timeout,
          :h,
          :help,
          :v,
          :fields
        ].freeze

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
        # @option arguments [List] :fields A comma-separated list of fields to include in the output
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, m, g)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                   (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/cat-fielddata.html
        #
        def fielddata(arguments={})
          fielddata_request_for(arguments).body
        end

        def fielddata_request_for(arguments={})
          fields = arguments.delete(:fields)

          method = HTTP_GET
          path   = Utils.__pathify "_cat/fielddata", Utils.__listify(fields)
          params = Utils.__validate_and_extract_params arguments, VALID_FIELDDATA_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
