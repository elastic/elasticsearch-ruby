module Elasticsearch
  module API
    module Indices
      module Actions

        VALID_FLUSH_SYNCED_PARAMS = [].freeze
        # @option arguments [List] :index A comma-separated list of index names; use `_all` or empty string for all indices
        # @option arguments [Boolean] :ignore_unavailable Whether specified concrete indices should be ignored when unavailable (missing or closed)
        # @option arguments [Boolean] :allow_no_indices Whether to ignore if a wildcard indices expression resolves into no concrete indices. (This includes `_all` string or when no indices have been specified)
        # @option arguments [String] :expand_wildcards Whether to expand wildcard expression to concrete indices that are open, closed or both. (options: open, closed, none, all)
        #
        # @see http://www.elastic.co/guide/en/elasticsearch/reference/master/indices-flush.html
        #
        def flush_synced(arguments={})
          if Array(arguments[:ignore]).include?(404)
            Utils.__rescue_from_not_found { flush_synced_request_for(arguments).body }
          else
            flush_synced_request_for(arguments).body
          end
        end

        def flush_synced_request_for(arguments={})
          method = HTTP_POST
          path   = Utils.__pathify Utils.__listify(arguments[:index]), '_flush/synced'

          params = Utils.__validate_and_extract_params arguments, VALID_FLUSH_SYNCED_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
