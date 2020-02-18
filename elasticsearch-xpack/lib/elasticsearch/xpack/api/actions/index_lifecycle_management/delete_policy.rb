# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module IndexLifecycleManagement
        module Actions
          # Deletes a lifecycle policy
          #
          # @option arguments [String] :policy_id Identifier for the policy
          # @option arguments [Time] :master_timeout Specifies the period of time to wait for a connection to the master node
          # @option arguments [Time] :timeout Specifies the period of time to wait for a response.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ilm-delete-lifecycle.html
          #
          def delete_policy(arguments = {})
            raise ArgumentError, "Required argument 'policy_id' missing" unless arguments[:policy_id]

            method = Elasticsearch::API::HTTP_DELETE
            path   = Elasticsearch::API::Utils.__pathify "_ilm/policy",
                                                         Elasticsearch::API::Utils.__escape(arguments[:policy_id])
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = nil

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          ParamsRegistry.register(:delete_policy, [:master_timeout,
                                                   :timeout].freeze)
        end
      end
    end
  end
end
