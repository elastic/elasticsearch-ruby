# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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
