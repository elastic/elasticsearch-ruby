# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'test_helper'
require 'pathname'

require 'elasticsearch/extensions/test/cluster'

class Elasticsearch::Extensions::TestClusterIntegrationTest < Elasticsearch::Test::IntegrationTestCase
  context "The Test::Cluster" do
    PATH_TO_BUILDS = if ENV['PATH_TO_BUILDS']
      Pathname(ENV['PATH_TO_BUILDS'])
    else
      Pathname(File.expand_path('../../../../../../tmp/builds', __FILE__))
    end

    unless PATH_TO_BUILDS.exist?
      puts "Path to builds doesn't exist, skipping TestClusterIntegrationTest"
      exit(0)
    end

    @builds = begin
      PATH_TO_BUILDS.entries.reject { |f| f.to_s =~ /^\./ }.sort
    rescue Errno::ENOENT
      []
    end

    STDOUT.puts %Q|Builds: \n#{@builds.map { |b| "  * #{b}"}.join("\n")}| unless ENV['QUIET']

    @builds.each do |build|
      should "start and stop #{build.to_s}" do
        puts ("----- #{build.to_s} " + "-"*(80-7-build.to_s.size)).to_s.ansi(:bold)
        begin
          Elasticsearch::Extensions::Test::Cluster.start \
            command: PATH_TO_BUILDS.join(build.join('bin/elasticsearch')).to_s,
            port: 9260,
            cluster_name: 'elasticsearch-ext-integration-test',
            path_data: '/tmp/elasticsearch-ext-integration-test'

          # Index some data to create the data directory
          client = Elasticsearch::Client.new host: "localhost:9260"
          client.index index: 'test1', type: 'd', id: 1, body: { title: 'TEST' }
        ensure
          Elasticsearch::Extensions::Test::Cluster.stop \
            command: PATH_TO_BUILDS.join(build.join('bin/elasticsearch')).to_s,
            port: 9260,
            cluster_name: 'elasticsearch-ext-integration-test'
        end
      end
    end
  end
end
