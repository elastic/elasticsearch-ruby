module Elasticsearch
  module API
    module Actions

      # Remove an indexed script from Elasticsearch
      #
      # @option arguments [String] :id Script ID (*Required*)
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [Time] :master_timeout Specify timeout for connection to master
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/modules-scripting.html
      #
      def delete_script(arguments={})
        raise ArgumentError, "Required argument 'id' missing"   unless arguments[:id]
        method = HTTP_DELETE
        path   = "_scripts/#{arguments.has_key?(:lang) ? "#{arguments.delete(:lang)}/" : ''}#{arguments[:id]}"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = nil

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:delete_script, [
          :timeout,
          :master_timeout ].freeze)
    end
  end
end
