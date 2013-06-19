module Elasticsearch
  module API
    module Indices
      module Actions

        # Return true if the specified alias exists, false otherwise.
        #
        # @option arguments [List] :index A comma-separated list of index names to filter aliases
        # @option arguments [List] :name A comma-separated list of alias names to return (*Required*)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-aliases/
        #
        def exists_alias(arguments={})
          raise ArgumentError, "Required argument 'name' missing" unless arguments[:name]
          method = 'HEAD'
          path   = Utils.__pathify( Utils.__listify(arguments[:index]), '_alias', arguments[:name] )
          params = arguments.select do |k,v|
            [ :ignore_indices ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body = nil

          perform_request(method, path, params, body).status == 200 ? true : false
        rescue Exception => e
          if e.class.to_s =~ /NotFound/ || e.message =~ /Not\s*Found|404/i
            false
          else
            raise e
          end
        end
      end
    end
  end
end
