# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module AsyncSearch
        module Actions; end

        class AsyncSearchClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, AsyncSearch::Actions
        end

        def async_search
          @async_search ||= AsyncSearchClient.new(self)
        end

      end
    end
  end
end
