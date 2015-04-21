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
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]
        method = HTTP_GET
        path   = "_search/template/#{arguments[:id]}"
        params = {}
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      rescue Exception => e
        # NOTE: Use exception name, not full class in Elasticsearch::Client to allow client plugability
        if Array(arguments[:ignore]).include?(404) && e.class.to_s =~ /NotFound/; false
        else raise(e)
        end
      end
    end
  end
end
