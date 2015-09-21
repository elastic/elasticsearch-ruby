module Elasticsearch
  module API
    module Cat
      module Actions

        VALID_SEGMENTS_PARAMS = [
          :h,
          :help,
          :v
        ].freeze

        # Display information about the segments in the shards of an index
        #
        # @example Display information for all indices
        #
        #     puts client.cat.segments
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/cat-segments.html
        #
        def segments(arguments={})
          segments_request_for(arguments).body
        end

        def segments_request_for(arguments={})
          method = 'GET'
          path   = "_cat/segments"
          params = Utils.__validate_and_extract_params arguments, VALID_SEGMENTS_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
