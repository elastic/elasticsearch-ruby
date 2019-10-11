# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module IndexLifecycleManagement
        module Actions

          # Triggers execution of a specific step in the lifecycle policy
          #
          # @option arguments [String] :index The target index (*Required*)
          # @option arguments [Hash] :body The request template content (*Required*)
          # @option arguments [Time] :master_timeout Specifies the period of time to wait for a connection to the master node
          # @option arguments [Time] :timeout Specifies the period of time to wait for a response.
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/ilm-move-to-step.html
          #
          def move_to_step(arguments={})
            raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
            raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]
            method = Elasticsearch::API::HTTP_POST
            index = Elasticsearch::API::Utils.__escape(arguments.delete(:index))
            path   = Elasticsearch::API::Utils.__pathify "_ilm/move",
                                                         index
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)
            body   = arguments[:body]

            perform_request(method, path, params, body).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          ParamsRegistry.register(:move_to_step, [ :master_timeout,
                                                   :timeout ].freeze)
        end
      end
    end
  end
end
