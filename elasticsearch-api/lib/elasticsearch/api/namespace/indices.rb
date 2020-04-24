# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Indices
      module Actions; end

      # Client for the "indices" namespace (includes the {Indices::Actions} methods)
      #
      class IndicesClient
        include Common::Client, Common::Client::Base, Indices::Actions
      end

      # Proxy method for {IndicesClient}, available in the receiving object
      #
      def indices
        @indices ||= IndicesClient.new(self)
      end

    end
  end
end
