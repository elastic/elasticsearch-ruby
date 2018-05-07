module Elasticsearch
  module API
    module Actions

      # Retrieve an indexed script from Elasticsearch
      #
      # @option arguments [String] :id Script ID (*Required*)
      # @option arguments [String] :lang Script language
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/modules-scripting.html#_indexed_scripts
      #
      def get_script(arguments={})
        raise ArgumentError, "Required argument 'id' missing"   unless arguments[:id]
        method = HTTP_GET
        path   = "_scripts/#{arguments.has_key?(:lang) ? "#{arguments.delete(:lang)}/" : ''}#{arguments[:id]}"
        params = {}
        body   = nil

        perform_request(method, path, params, body).body
      end
    end
  end
end
