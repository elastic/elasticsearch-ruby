module Elasticsearch
  module API
    module Cat
      module Actions

        # Returns information about existing templates
        #
        # @option arguments [String] :name A pattern that returned template names must match
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cat-templates.html
        #
        def templates(arguments={})
          method = HTTP_GET
          name = arguments.delete(:name)
          path = Utils.__pathify( '_cat/templates', Utils.__escape(name))
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = nil

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:templates, [
            :format,
            :local,
            :master_timeout,
            :h,
            :help,
            :s,
            :v ].freeze)
      end
    end
  end
end
