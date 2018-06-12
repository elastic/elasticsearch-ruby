module Elasticsearch
  module XPack
    module API
      module SSL
        module Actions; end

        class SSLClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, SSL::Actions
        end

        def ssl
          @ssl ||= SSLClient.new(self)
        end

      end
    end
  end
end
