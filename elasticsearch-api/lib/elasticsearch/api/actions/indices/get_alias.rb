module Elasticsearch
  module API
    module Indices
      module Actions

        # Get information about a specific alias.
        #
        # @example Return all indices an alias points to
        #
        #     client.indices.get_alias name: '2013'
        #
        # @example Return all indices matching a wildcard pattern an alias points to
        #
        #     client.indices.get_alias index: 'log*', name: '2013'
        #
        # @option arguments [List] :index A comma-separated list of index names to filter aliases
        # @option arguments [List] :name A comma-separated list of alias names to return (*Required*)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        # @option arguments [List] :index A comma-separated list of index names to filter aliases
        # @option arguments [List] :name A comma-separated list of alias names to return
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases/
        #
        def get_alias(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          method = 'GET'
          path   = Utils.__pathify( Utils.__listify(arguments[:index]), '_alias', arguments[:name] )
          params = arguments.select do |k,v|
            [ :ignore_indices ].include?(k)
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
