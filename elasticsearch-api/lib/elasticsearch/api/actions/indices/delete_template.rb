module Elasticsearch
  module API
    module Indices
      module Actions

        DELETE_TEMPLATE_PARAMS = [ :timeout ].freeze

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
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-templates/
        #
        def delete_template(arguments={})
          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { delete_template_request_for(arguments).body }
          else
            delete_template_request_for(arguments).body
          end
        end

        def delete_template_request_for(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          method = HTTP_DELETE
          path   = Utils.__pathify '_template', Utils.__escape(arguments[:name])

          params = Utils.__validate_and_extract_params arguments, DELETE_TEMPLATE_PARAMS
          body = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
