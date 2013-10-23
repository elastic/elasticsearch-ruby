module Elasticsearch
  module API
    module Indices
      module Actions

        # Return true if the specified type exists, false otherwise.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all`
        #                                 to check the types across all indices (*Required*)
        # @option arguments [List] :type A comma-separated list of document types to check (*Required*)
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-types-exists/
        #
        def exists_type(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          raise ArgumentError, "Required argument 'type' missing" unless arguments[:type]
          valid_params = [ :ignore_indices ]

          method = 'HEAD'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), Utils.__escape(arguments[:type])

          params = Utils.__validate_and_extract_params arguments, valid_params
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
