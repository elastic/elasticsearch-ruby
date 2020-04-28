# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Ingest
      module Actions
        # Allows to simulate a pipeline with example documents.
        #
        # @option arguments [String] :id Pipeline ID
        # @option arguments [Boolean] :verbose Verbose mode. Display data output for each processor in executed pipeline
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The simulate definition (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/simulate-pipeline-api.html
        #
        def simulate(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _id
                     "_ingest/pipeline/#{Utils.__listify(_id)}/_simulate"
                   else
                     "_ingest/pipeline/_simulate"
  end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:simulate, [
          :verbose
        ].freeze)
end
      end
  end
end
