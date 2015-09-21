module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_GET_TEMPLATE_PARAMS = [
          :flat_settings,
          :local,
          :master_timeout
        ].freeze

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
        # @option arguments [String] :name The name of the template (supports wildcards)
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-templates/
        #
        def get_template(arguments={})
          get_template_request_for(arguments).body
        end

        def get_template_request_for(arguments={})

          method = HTTP_GET
          path   = Utils.__pathify '_template', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, VALID_GET_TEMPLATE_PARAMS
          body   = arguments[:body]

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
