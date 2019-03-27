module Elasticsearch
  module API
    module Cat
      module Actions

        # Help information for the Cat API
        #
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/cat.html
        #
        def help(arguments={})
          method = HTTP_GET
          path   = "_cat"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:help, [
            :help,
            :s ].freeze)
      end
    end
  end
end
