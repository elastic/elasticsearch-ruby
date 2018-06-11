module Elasticsearch
  module XPack
    module API
      module License
        module Actions; end

        class LicenseClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, License::Actions
        end

        def license
          @license ||= LicenseClient.new(self)
        end

      end
    end
  end
end
