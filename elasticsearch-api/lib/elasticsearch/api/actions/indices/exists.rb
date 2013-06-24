module Elasticsearch
  module API
    module Indices
      module Actions

        # Return true if the index (or all indices in a list) exists, false otherwise.
        #
        # @example Check whether index named _myindex_ exists
        #
        #     client.indices.exists index: 'myindex'
        #
        # @option arguments [List] :index A comma-separated list of indices to check (*Required*)
        # @return [true,false]
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-indices-exists/
        #
        def exists(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = 'HEAD'
          path   = Utils.__listify(arguments[:index])
          params = {}
          body   = nil

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
