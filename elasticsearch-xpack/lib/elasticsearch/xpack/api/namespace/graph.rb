module Elasticsearch
  module XPack
    module API
      module Graph
        module Actions; end

        class GraphClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, Graph::Actions
        end

        def graph
          @graph ||= GraphClient.new(self)
        end

      end
    end
  end
end
