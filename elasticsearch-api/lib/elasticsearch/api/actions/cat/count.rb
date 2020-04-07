# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Cat
      module Actions
        # Provides quick access to the document count of the entire cluster, or individual indices.
        #
        # @option arguments [List] :index A comma-separated list of index names to limit the returned information
        # @option arguments [String] :format a short version of the Accept header, e.g. json, yaml
        # @option arguments [List] :h Comma-separated list of column names to display
        # @option arguments [Boolean] :help Return help information
        # @option arguments [List] :s Comma-separated list of column names or column aliases to sort by
        # @option arguments [Boolean] :v Verbose mode. Display column headers
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/cat-count.html
        #
        def count(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _index = arguments.delete(:index)

          method = Elasticsearch::API::HTTP_GET
          path   = if _index
                     "_cat/count/#{Utils.__listify(_index)}"
                   else
                     "_cat/count"
      end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
          params[:h] = Utils.__listify(params[:h]) if params[:h]

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:count, [
          :format,
          :h,
          :help,
          :s,
          :v
        ].freeze)
end
      end
  end
end
