module Elasticsearch
  module API
    module Cat
      module Actions

        # TODO: Description
        #
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/cat-nodes.html
        #
        def nodes(arguments={})
          valid_params = [
            :local,
            :master_timeout,
            :h,
            :help,
            :v ]

          method = 'GET'
          path   = "_cat/nodes"

          params = Utils.__validate_and_extract_params arguments, valid_params

          params[:h] = Utils.__listify(params[:h]) if params[:h]

          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
