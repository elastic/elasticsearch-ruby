module Elasticsearch
  module XPack
    module API
      module Migration
        module Actions; end

        class MigrationClient
          include Elasticsearch::API::Common::Client, Elasticsearch::API::Common::Client::Base, Migration::Actions
        end

        def migration
          @migration ||= MigrationClient.new(self)
        end

      end
    end
  end
end
