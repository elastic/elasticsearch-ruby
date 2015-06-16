module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_GET_PARAMS = [
          :local,
          :ignore_unavailable,
          :allow_no_indices,
          :expand_wildcards
        ].freeze

        # Retrieve information about one or more indices
        #
        # @option arguments [List] :index A comma-separated list of index names (*Required*)
        # @option arguments [List] :feature A comma-separated list of features
        # @option arguments [Boolean] :local Return local information, do not retrieve the state from master node
        #                                    (default: false)
        # @option arguments [Boolean] :ignore_unavailable Ignore unavailable indexes (default: false)
        # @option arguments [Boolean] :allow_no_indices Ignore if a wildcard expression resolves to no concrete
        #                                               indices (default: false)
        # @option arguments [List] :expand_wildcards Whether wildcard expressions should get expanded
        #                                            to open or closed indices (default: open)
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/indices-get-index.html
        #
        def get(arguments={})
          get_request_for(arguments).body
        end

        def get_request_for(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          method = HTTP_GET

          path   = Utils.__pathify Utils.__listify(arguments[:index]), Utils.__listify(arguments.delete(:feature))

          params = Utils.__validate_and_extract_params arguments, VALID_GET_PARAMS
          body = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
