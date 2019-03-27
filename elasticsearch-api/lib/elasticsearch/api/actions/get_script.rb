module Elasticsearch
  module API
    module Actions

      # Retrieve an indexed script from Elasticsearch
      #
      # @option arguments [String] :id Script ID (*Required*)
      # @option arguments [Time] :master_timeout Specify timeout for connection to master
      #
      # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/modules-scripting.html
      #
      def get_script(arguments={})
        raise ArgumentError, "Required argument 'id' missing"   unless arguments[:id]
        method = HTTP_GET
        path   = "_scripts/#{arguments.has_key?(:lang) ? "#{arguments.delete(:lang)}/" : ''}#{arguments[:id]}"
        params = {}
        body   = nil

        perform_request(method, path, params, body).body
      end


      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:get_script, [
          :master_timeout ].freeze)
    end
  end
end
