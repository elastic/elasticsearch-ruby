module Elasticsearch
  module API
    module Actions

      # Pre-render search requests before they are executed and fill existing templates with template parameters
      #
      # @option arguments [String] :id The id of the stored search template
      # @option arguments [Hash] :body The search definition template and its params
      #
      # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/current/search-template.html
      #
      def render_search_template(arguments={})
        method = 'GET'
        path   = "_render/template"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
        body   = arguments[:body]

        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:render_search_template, [
          :id ].freeze)
    end
  end
end
