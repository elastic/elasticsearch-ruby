# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module SQL
        module Actions; end

        class SQLClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, SQL::Actions
        end

        def sql
          @sql ||= SQLClient.new(self)
        end

      end
    end
  end
end
