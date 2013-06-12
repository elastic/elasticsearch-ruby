module Elasticsearch
  module API
    module Indices
      module Actions; end

      class IndicesClient
        include Common::Client, Actions
      end

      def indices
        @indices ||= IndicesClient.new(self)
      end

    end
  end
end
