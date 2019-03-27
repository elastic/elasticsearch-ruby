module Elasticsearch
  module API
    module Indices
      module Actions

        # Delete an index template.
        #
        # @example Delete a template named _mytemplate_
        #
        #     client.indices.delete_template name: 'mytemplate'
        #
        # @example Delete all templates
        #
        #     client.indices.delete_template name: '*'
        #
        # @option arguments [String] :name The name of the template (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Time] :master_timeout Specify timeout for connection to master
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/indices-templates.html
        #
        def delete_template(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          method = HTTP_DELETE
          path   = Utils.__pathify '_template', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          body = nil

          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { perform_request(method, path, params, body).body }
          else
            perform_request(method, path, params, body).body
          end
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:delete_template, [
            :timeout,
            :master_timeout ].freeze)
      end
    end
  end
end
