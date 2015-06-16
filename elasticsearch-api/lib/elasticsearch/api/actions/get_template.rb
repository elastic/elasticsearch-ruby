module Elasticsearch
  module API
    module Actions

      # Retrieve an indexed script from Elasticsearch
      #
      # @option arguments [String] :id Template ID (*Required*)
      # @option arguments [Hash] :body The document
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/search-template.html
      #
      def get_template(arguments={})
        if Array(arguments[:ignore]).include?(404)
          Utils.__rescue_from_not_found { get_template_request_for(arguments).body }
        else
          get_template_request_for(arguments).body
        end
      end

      def get_template_request_for(arguments)
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
        method = HTTP_GET
        path   = "_search/template/#{arguments[:id]}"
        params = {}
        body   = arguments[:body]

        perform_request(method, path, params, body)
      end
    end
  end
end
