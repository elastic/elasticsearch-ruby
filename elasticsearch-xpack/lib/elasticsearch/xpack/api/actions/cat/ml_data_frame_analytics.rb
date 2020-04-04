# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Cat
        module Actions
          # TODO: Description

          #
          # @option arguments [String] :id The ID of the data frame analytics to fetch
          # @option arguments [Boolean] :allow_no_match Whether to ignore if a wildcard expression matches no configs. (This includes `_all` string or when no configs have been specified)
          # @option arguments [String] :bytes The unit in which to display byte values
          #   (options: b,k,kb,m,mb,g,gb,t,tb,p,pb)

          # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
          # @option arguments [List] :h Comma-separated list of column names to display
          # @option arguments [Boolean] :help Return help information
          # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
          # @option arguments [String] :time The unit in which to display time values
          #   (options: d (Days),h (Hours),m (Minutes),s (Seconds),ms (Milliseconds),micros (Microseconds),nanos (Nanoseconds))

          # @option arguments [Boolean] :v Verbose mode. Display column headers

          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/cat-dfanalytics.html
          #
          def ml_data_frame_analytics(arguments = {})
            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_GET
            path   = if _id
                       "_cat/ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}"
                     else
                       "_cat/ml/data_frame/analytics"
  end
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:ml_data_frame_analytics, [
            :allow_no_match,
            :bytes,
            :format,
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
end
