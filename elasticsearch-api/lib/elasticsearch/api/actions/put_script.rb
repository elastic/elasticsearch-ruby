module Elasticsearch
  module API
    module Actions

      # Store a script in an internal index (`.scripts`), to be able to reference them
      # in search definitions (with dynamic scripting disabled)
      #
      # @example Storing an Mvel script in Elasticsearch and using it in function score
      #
      #     client.put_script lang: 'groovy', id: 'my_score', body: { script: 'log(_score * factor)' }
      #
      #     client.search body: {
      #       query: {
      #         function_score: {
      #           query: { match: { title: 'foo' } },
      #           functions: [ { script_score: { script_id: 'my_score', params: { factor: 3 } } } ]
      #         }
      #       }
      #     }
      #
      # @option arguments [String] :id Script ID (*Required*)
      # @option arguments [String] :context Script context
      # @option arguments [Hash] :body The document (*Required*)
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Time] :master_timeout Specify timeout for connection to master
      # @option arguments [String] :context Context name to compile script against
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-scripting.html#_indexed_scripts
      #
      def put_script(arguments={})
        raise ArgumentError, "Required argument 'id' missing"   unless arguments[:id]
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
        method = HTTP_PUT
        path   = "_scripts/#{arguments.has_key?(:lang) ? "#{arguments.delete(:lang)}/" : ''}#{arguments[:id]}"

        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end


      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:put_script, [
          :timeout,
          :master_timeout,
          :context ].freeze)
    end
  end
end
