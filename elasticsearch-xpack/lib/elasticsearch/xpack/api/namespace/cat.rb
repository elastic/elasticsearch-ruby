# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module Cat
        module Actions; end

        class CatClient < Elasticsearch::API::Cat::CatClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, Cat::Actions
        end

        def cat
          @cat ||= CatClient.new(self)
        end
      end
    end
  end
end
