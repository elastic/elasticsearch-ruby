# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Returns a script.
      #
      # @option arguments [String] :id Script ID
      # @option arguments [Time] :master_timeout Specify timeout for connection to master

      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/7.5/modules-scripting.html
      #
      def get_script(arguments = {})
        raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

        arguments = arguments.clone

        _id = arguments.delete(:id)

        method = Elasticsearch::API::HTTP_GET
        path   = "_scripts/#{Utils.__listify(_id)}"
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = nil
        perform_request(method, path, params, body).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:get_script, [
        :master_timeout
      ].freeze)
    end
    end
end
