# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require "bundler/gem_tasks"

desc "Run unit tests"
task :default => 'test:unit'
task :test    => 'test:unit'

# ----- Test tasks ------------------------------------------------------------

require 'rake/testtask'
require 'rspec/core/rake_task'

namespace :test do

  desc "Wait for Elasticsearch to be in a green state"
  task :wait_for_green do
    sh '../scripts/wait-cluster.sh'
  end

  task :spec => :wait_for_green
  RSpec::Core::RakeTask.new(:spec)

  Rake::TestTask.new(:unit) do |test|
    test.libs << 'lib' << 'test'
    test.test_files = FileList["test/unit/**/*_test.rb"]
    test.verbose = false
    test.warning = false
  end

  Rake::TestTask.new(:integration) do |test|
    test.libs << 'lib' << 'test'
    test.test_files = FileList["test/integration/**/*_test.rb"]
    test.deps = [ 'test:wait_for_green', 'test:spec' ]
    test.verbose = false
    test.warning = false
  end

  Rake::TestTask.new(:all) do |test|
    test.libs << 'lib' << 'test'
    test.test_files = FileList["test/unit/**/*_test.rb", "test/integration/**/*_test.rb"]
  end

  Rake::TestTask.new(:profile) do |test|
    test.libs << 'lib' << 'test'
    test.test_files = FileList["test/profile/**/*_test.rb"]
  end

  namespace :cluster do
    desc "Start Elasticsearch nodes for tests"
    task :start do
      $LOAD_PATH << File.expand_path('../lib', __FILE__) << File.expand_path('../test', __FILE__)
      require 'elasticsearch/extensions/test/cluster'
      Elasticsearch::Extensions::Test::Cluster.start
    end

    desc "Stop Elasticsearch nodes for tests"
    task :stop do
      $LOAD_PATH << File.expand_path('../lib', __FILE__) << File.expand_path('../test', __FILE__)
      require 'elasticsearch/extensions/test/cluster'
      Elasticsearch::Extensions::Test::Cluster.stop
    end
  end
end

# ----- Documentation tasks ---------------------------------------------------

require 'yard'
YARD::Rake::YardocTask.new(:doc) do |t|
  t.options = %w| --embed-mixins --markup=markdown |
end

# ----- Code analysis tasks ---------------------------------------------------

if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  require 'cane/rake_task'
  Cane::RakeTask.new(:quality) do |cane|
    cane.abc_max = 15
    cane.no_style = true
  end
end
