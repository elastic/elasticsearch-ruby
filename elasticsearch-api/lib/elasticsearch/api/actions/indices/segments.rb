module Elasticsearch
  module API
    module Indices
      module Actions

        # Return information about segments for one or more indices.
        #
        # The response contains information about segment size, number of documents, deleted documents, etc.
        # See also {Indices::Actions#optimize}.
        #
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string
        #                                 to perform the operation on all indices
        # @option arguments [String] :ignore_indices When performed on multiple indices, allows to ignore `missing` ones
        #                                            (options: none, missing)
        #
        # @see http://elasticsearch.org/guide/reference/api/admin-indices-segments/
        #
        def segments(arguments={})
          method = 'GET'
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_segments'
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
