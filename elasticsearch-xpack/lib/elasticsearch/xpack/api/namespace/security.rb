module Elasticsearch
  module XPack
    module API
      module Security
        module Actions; end

        class SecurityClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, Security::Actions
        end

        def security
          @security ||= SecurityClient.new(self)
        end

      end
    end
  end
end
