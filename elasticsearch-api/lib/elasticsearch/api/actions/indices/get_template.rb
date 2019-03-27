module Elasticsearch
  module API
    module Indices
      module Actions

        # Get a single index template.
        #
        # @example Get all templates
        #
        #     client.indices.get_template
        #
        # @example Get a template named _mytemplate_
        #
        #     client.indices.get_template name: 'mytemplate'
        #
        # @note Use the {Cluster::Actions#state} API to get a list of all templates.
        #
        # @option arguments [List] :name The comma separated names of the index templates
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html
        #
        def get_template(arguments={})
          method = HTTP_GET
          path   = Utils.__pathify '_template', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get_template, [
            :flat_settings,
            :master_timeout,
            :local,
            :include_type_name ].freeze)
      end
    end
  end
end
