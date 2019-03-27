module Elasticsearch
  module API
    module Ingest
      module Actions

        # Execute a specific pipeline against the set of documents provided in the body of the request
        #
        # @option arguments [String] :id Pipeline ID
        # @option arguments [Hash] :body The simulate definition (*Required*)
        # @option arguments [Boolean] :verbose Verbose mode. Display data output for each processor in executed pipeline
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/plugins/current/ingest.html
        #
        def simulate(arguments={})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = 'GET'
          path   = Utils.__pathify "_ingest/pipeline", Utils.__escape(arguments[:id]), '_simulate'
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:simulate, [
            :verbose ].freeze)
      end
    end
  end
end
