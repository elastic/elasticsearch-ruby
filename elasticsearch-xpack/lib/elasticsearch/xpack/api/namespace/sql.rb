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
