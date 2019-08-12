# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Monitoring
        module Actions

          # Insert monitoring data in bulk
          #
          # @option arguments [String] :type Default document type for items which don't provide one
          # @option arguments [Hash] :body The operation definition and data (action-data pairs), separated by newlines (*Required*)
          # @option arguments [String] :system_id Identifier of the monitored system
          # @option arguments [String] :system_api_version API version of the monitored system
          # @option arguments [String] :system_version Version of the monitored system
          #
          # @see http://www.elastic.co/guide/en/monitoring/current/appendix-api-bulk.html
          #
          def bulk(arguments={})
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            arguments = arguments.clone
            type = arguments.delete(:type)
            body = arguments.delete(:body)

            method = Elasticsearch::API::HTTP_POST
            path   = Elasticsearch::API::Utils.__pathify '_xpack/monitoring', type, '_bulk'
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            if body.is_a? Array
              payload = Elasticsearch::API::Utils.__bulkify(body)
            else
              payload = body
            end

            perform_request(method, path, params, payload).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:bulk, [ :system_id,
                                           :system_api_version,
                                           :system_version,
                                           :interval ].freeze)
        end
      end
    end
  end
end
