require "multi_json"

require "elasticsearch/api/version"
require "elasticsearch/namespace/common"
require "elasticsearch/utils"

Dir[ File.expand_path('../api/**/*.rb', __FILE__) ].each       { |f| require f }
Dir[ File.expand_path('../namespace/**/*.rb', __FILE__) ].each { |f| require f }

module Elasticsearch
  module API
  end
end
