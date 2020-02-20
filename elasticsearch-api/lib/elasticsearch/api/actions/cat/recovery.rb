# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cat
      module Actions
        # Returns information about index shard recoveries, both on-going completed.
        #
        # @option arguments [List] :index Comma-separated list or wildcard expression of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :active_only If `true`, the response only includes ongoing shard recoveries
        # @option arguments [String] :bytes The unit in which to display byte values
        #   (options: b,k,kb,m,mb,g,gb,t,tb,p,pb)

        # @option arguments [Boolean] :detailed If `true`, the response includes detailed information about shard recoveries
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :index Comma-separated list or wildcard expression of index names to limit the returned information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values
        #   (options: d (Days),h (Hours),m (Minutes),s (Seconds),ms (Milliseconds),micros (Microseconds),nanos (Nanoseconds))

        # @option arguments [Boolean] :v Verbose mode. Display column headers

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/cat-recovery.html
        #
        def recovery(arguments = {})
          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "_cat/recovery/#{Utils.__listify(_index)}"
                   else
                     "_cat/recovery"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:recovery, [
          :format,
          :active_only,
          :bytes,
          :detailed,
          :h,
          :help,
          :index,
          :s,
          :time,
          :v
        ].freeze)
end
      end
  end
end
