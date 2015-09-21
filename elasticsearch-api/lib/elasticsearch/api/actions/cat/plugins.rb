module Elasticsearch
  module API
    module Cat
      module Actions

        VALID_PLUGINS_PARAMS = [
          :local,
          :master_timeout,
          :h,
          :help,
          :v
        ].freeze

        # Return information about installed plugins
        #
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/cat-plugins.html
        #
        def plugins(arguments={})
          plugins_request_for(arguments).body
        end

        def plugins_request_for(arguments={})
          method = 'GET'
          path   = "/_cat/plugins"
          params = Utils.__validate_and_extract_params arguments, VALID_PLUGINS_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
