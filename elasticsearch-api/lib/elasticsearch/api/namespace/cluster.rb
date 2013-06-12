module Elasticsearch
  module API
    module Cluster
      module Actions; end

      class ClusterClient
        include Common::Client, Actions
      end

      def cluster
        @cluster ||= ClusterClient.new(self)
      end

    end
  end
end
