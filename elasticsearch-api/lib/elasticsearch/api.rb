require "multi_json"

require "elasticsearch/api/version"
require "elasticsearch/api/namespace/common"
require "elasticsearch/api/utils"

Dir[ File.expand_path('../api/actions/**/*.rb', __FILE__) ].each   { |f| require f }
Dir[ File.expand_path('../api/namespace/**/*.rb', __FILE__) ].each { |f| require f }

module Elasticsearch
  module API
    def self.included(base)
      base.send :include,
                Elasticsearch::API::Common,
                Elasticsearch::API::Common::Client,
                Elasticsearch::API::Actions,
                Elasticsearch::API::Cluster,
                Elasticsearch::API::Cluster::Actions,
                Elasticsearch::API::Indices,
                Elasticsearch::API::Indices::Actions
    end
  end
end
