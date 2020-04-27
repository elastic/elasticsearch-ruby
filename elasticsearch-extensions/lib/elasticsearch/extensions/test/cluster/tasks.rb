# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'elasticsearch/extensions/test/cluster'

namespace :elasticsearch do
  desc "Start Elasticsearch cluster for tests"
  task :start do
    Elasticsearch::Extensions::Test::Cluster.start
  end

  desc "Stop Elasticsearch cluster for tests"
  task :stop do
    Elasticsearch::Extensions::Test::Cluster.stop
  end
end
