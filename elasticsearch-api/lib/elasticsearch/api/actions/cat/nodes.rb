# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cat
      module Actions
        # Returns basic statistics about performance of cluster nodes.
        #
        # @option arguments [String] :bytes The unit in which to display byte values
        #   (options: b,k,kb,m,mb,g,gb,t,tb,p,pb)

        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :full_id Return the full node ID instead of the shortened version (default: false)
        # @option arguments [Boolean] :local Calculate the selected nodes using the local cluster state rather than the state from master node (default: false)   *Deprecated*
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values
        #   (options: d,h,m,s,ms,micros,nanos)

        # @option arguments [Boolean] :v Verbose mode. Display column headers

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/cat-nodes.html
        #
        def nodes(arguments = {})
          arguments = arguments.clone

          method = Elasticsearch::API::HTTP_GET
          path   = "_cat/nodes"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h], escape: false) if params[:h]

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:nodes, [
          :bytes,
          :format,
          :full_id,
          :local,
          :master_timeout,
          :h,
          :help,
          :s,
          :time,
          :v
        ].freeze)
end
      end
  end
end
