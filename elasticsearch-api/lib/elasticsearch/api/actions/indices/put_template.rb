module Elasticsearch
  module API
    module Indices
      module Actions

        # Create or update an index template.
        #
        #
        # @example Create a template for all indices starting with `logs-`
        #
        #     client.indices.put_template :name => 'foo',
        #                                 :body => { template: 'logs-*', settings: { 'index.number_of_shards' => 1 } }
        #
        # @option arguments [String] :name The name of the template (*Required*)
        # @option arguments [Hash] :body The template definition (*Required*)
        # @option arguments [Number] :order The order for this template when merging multiple matching ones
        #                                   (higher numbers are merged later, overriding the lower numbers)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-templates/
        #
        def put_template(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          method = 'PUT'
          path   = "_template/#{arguments[:name]}"
          path   = Utils.__pathify '_template', Utils.__escape(arguments[:name])
          params = arguments.select do |k,v|
            [ :order,
              :timeout ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body   = arguments[:body]

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
