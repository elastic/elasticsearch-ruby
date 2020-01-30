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

        #
        # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/get-pipeline-api.html
        #
        def get_pipeline(arguments = {})
          arguments = arguments.clone

          _id = arguments.delete(:id)

          method = HTTP_GET
          path   = if _id
                     "_ingest/pipeline/#{Utils.__listify(_id)}"
                   else
                     "_ingest/pipeline"
end
          params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

          body = nil
          perform_request(method, path, params, body).body
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
