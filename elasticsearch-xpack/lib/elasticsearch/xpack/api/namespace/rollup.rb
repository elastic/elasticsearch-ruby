module Elasticsearch
  module XPack
    module API
      module Rollup
        module Actions; end

        class RollupClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, Rollup::Actions
        end

        def rollup
          @rollup ||= RollupClient.new(self)
        end

      end
    end
  end
end
