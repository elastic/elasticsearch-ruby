module Elasticsearch
  module API
    module Indices
      module Actions

        # Return true if the specified index template exists, false otherwise.
        #
        #     client.indices.exists_template? name: 'mytemplate'
        #
        # @option arguments [List] :name The comma separated names of the index templates (*Required*)
        # @option arguments [Boolean] :flat_settings Return settings in flat format (default: false)
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node (default: false)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html
        #
        def exists_template(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          method = HTTP_HEAD
          path   = Utils.__pathify '_template', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          Utils.__rescue_from_not_found do
            perform_request(method, path, params, body).status == 200 ? true : false
          end
        end
        alias_method :exists_template?, :exists_template

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:exists_template, [
            :flat_settings,
            :master_timeout,
            :local ].freeze)
      end
    end
  end
end
