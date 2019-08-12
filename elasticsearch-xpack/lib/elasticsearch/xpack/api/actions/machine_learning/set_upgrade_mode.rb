# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions

          # Temporarily halt tasks associated with the jobs and datafeeds and prevent new jobs from opening.
          # When enabled=true this API temporarily halts all job and datafeed tasks and prohibits new job and
          #   datafeed tasks from starting.
          #
          # @option arguments [ true, false ] :enabled Whether to enable upgrade_mode ML setting or not. Defaults to false.
          # @option arguments [String] :timeout Controls the time to wait before action times out. Defaults to 30 seconds.
          #
          # @see http://www.elastic.co/guide/en/elasticsearch/reference/current/ml-set-upgrade-mode.html
          #
          def set_upgrade_mode(arguments={})
            method = Elasticsearch::API::HTTP_POST
            path   = '_ml/set_upgrade_mode'
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            perform_request(method, path, params).body
          end


          # Register this action with its valid params when the module is loaded.
          #
          # @since 7.4.0
          ParamsRegistry.register(:set_upgrade_mode, [ :enabled,
                                                       :timeout ].freeze)
        end
      end
    end
  end
end
