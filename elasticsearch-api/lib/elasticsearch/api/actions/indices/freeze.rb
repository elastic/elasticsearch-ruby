module Elasticsearch
  module API
    module Indices
      module Actions

        # In order to keep indices available and queryable for a longer period but at the same time reduce their
        #   hardware requirements they can be transitioned into a frozen state. Once an index is frozen, all of its
        #   transient shard memory (aside from mappings and analyzers) is moved to persistent storage.
        #
        # @option arguments [List] :index A comma separated list of indices to freeze. (*Required*)
        #
        # @note This feature is available in the Platinum distribution of Elasticsearch.
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/frozen-indices.html
        #
        def freeze(arguments = {})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]

          valid_params = [
              :timeout,
              :master_timeout,
              :ignore_unavailable,
              :allow_no_indices,
              :expand_wildcards,
              :wait_for_active_shards]

          arguments = arguments.clone
          index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_POST
          path = Elasticsearch::API::Utils.__pathify Elasticsearch::API::Utils.__listify(index), '_freeze'
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params

          perform_request(method, path, params).body
        end
      end
    end
  end
end
