module Elasticsearch
  module XPack
    module API
      module Monitoring
        module Actions; end

        class MonitoringClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, Monitoring::Actions
        end

        def monitoring
          @monitoring ||= MonitoringClient.new(self)
        end

      end
    end
  end
end
