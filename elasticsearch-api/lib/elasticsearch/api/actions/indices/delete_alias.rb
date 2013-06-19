module Elasticsearch
  module API
    module Indices
      module Actions

        # Delete a single index alias.
        #
        # @option arguments [String] :index The name of the index with an alias (*Required*)
        # @option arguments [String] :name The name of the alias to be deleted (*Required*)
        # @option arguments [Time] :timeout Explicit timestamp for the document
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases/
        #
        def delete_alias(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'name' missing"  unless arguments[:name]
          method = 'DELETE'
          path   = "#{arguments[:index]}/_alias/#{arguments[:name]}"
          params = arguments.select do |k,v|
            [ :timeout ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
