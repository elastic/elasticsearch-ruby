module Elasticsearch
  module API
    module Cat
      module Actions

        # Display information about the segments in the shards of an index
        #
        # @example Display information for all indices
        #
        #     puts client.cat.segments
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [String] :bytes The unit in which to display byte values (options: b, k, kb, m, mb, g, gb, t, tb, p, pb)
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat-segments.html
        #
        def segments(arguments={})
          method = 'GET'
          index = arguments.delete(:index)
          path = Utils.__pathify( '_cat/segments', Utils.__escape(index))
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:segments, [
            :format,
            :bytes,
            :h,
            :help,
            :s,
            :v ].freeze)
      end
    end
  end
end
