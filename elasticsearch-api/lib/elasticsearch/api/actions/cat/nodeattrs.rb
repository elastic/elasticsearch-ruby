module Elasticsearch
  module API
    module Cat
      module Actions

        # Display custom node attributes
        #
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/cat-nodeattrs.html
        #
        def nodeattrs(arguments={})
          valid_params = [
            :local,
            :master_timeout,
            :h,
            :help,
            :v ]

          unsupported_params = [ :format ]
          Utils.__report_unsupported_parameters(arguments.keys, unsupported_params)

          method = HTTP_GET
          path   = "_cat/nodeattrs"
          params = Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
