# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Ingest
      module Actions
        # Creates or updates a pipeline.
        #
        # @option arguments [String] :id Pipeline ID
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Time] :timeout Explicit operation timeout
        # @option arguments [Hash] :headers Custom HTTP headers
        # @option arguments [Hash] :body The ingest definition (*Required*)
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/put-pipeline-api.html
        #
        def put_pipeline(arguments = {})
          raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
          raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_PUT
          path   = "_ingest/pipeline/#{Utils.__listify(_id)}"
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = arguments[:body]
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:put_pipeline, [
          :master_timeout,
          :timeout
        ].freeze)
end
      end
  end
end
