# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cat
      module Actions
        # Returns all snapshots in a specific repository.
        #
        # @option arguments [List] :repository Name of repository from which to fetch the snapshot information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [Boolean] :ignore_unavailable Set to true to ignore unavailable snapshots
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [String] :time The unit in which to display time values
        #   (options: d (Days),h (Hours),m (Minutes),s (Seconds),ms (Milliseconds),micros (Microseconds),nanos (Nanoseconds))

        # @option arguments [Boolean] :v Verbose mode. Display column headers

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/cat-snapshots.html
        #
        def snapshots(arguments = {})
          arguments = arguments.clone

          _repository = arguments.delete(:repository)

          method = Elasticsearch::API::HTTP_GET
          path   = if _repository
                     "_cat/snapshots/#{Utils.__listify(_repository)}"
                   else
                     "_cat/snapshots"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:snapshots, [
          :format,
          :ignore_unavailable,
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
