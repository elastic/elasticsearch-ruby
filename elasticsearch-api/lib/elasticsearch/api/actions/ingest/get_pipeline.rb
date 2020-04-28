# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Ingest
      module Actions
        # Returns a pipeline.
        #
        # @option arguments [String] :id Comma separated list of pipeline ids. Wildcards supported
        # @option arguments [Time] :master_timeout Explicit operation timeout for connection to master node
        # @option arguments [Hash] :headers Custom HTTP headers
        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.7/get-pipeline-api.html
        #
        def get_pipeline(arguments = {})
          headers = arguments.delete(:headers) || {}

          arguments = arguments.clone

          _id = arguments.delete(:id)

          method = Elasticsearch::API::HTTP_GET
          path   = if _id
                     "_ingest/pipeline/#{Utils.__listify(_id)}"
                   else
                     "_ingest/pipeline"
      end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body, headers).body
        end

        # Register this action with its valid params when the module is loaded.
        #
        # @since 6.2.0
        ParamsRegistry.register(:get_pipeline, [
          :master_timeout
        ].freeze)
end
      end
  end
end
