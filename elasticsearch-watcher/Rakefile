require "bundler/gem_tasks"

task(:default) { system "rake --tasks" }
task  :test    => 'test:unit'

# ----- Test tasks ------------------------------------------------------------

require 'rake/testtask'
namespace :test do

  Rake::TestTask.new(:unit) do |test|
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    test.libs << 'lib' << 'test'
    test.test_files = FileList["test/unit/**/*_test.rb"]
    # test.verbose = true
    # test.warning = true
  end

  Rake::TestTask.new(:integration) do |test|
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    test.libs << 'lib' << 'test'
    test.test_files = FileList["test/integration/**/*_test.rb"]
  end

  desc "Run unit and integration tests"
  task :all do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    Rake::Task['test:unit'].invoke
    Rake::Task['test:integration'].invoke
  end

  namespace :cluster do
    desc "Start Elasticsearch nodes for tests"
    task :start do
      $LOAD_PATH << File.expand_path('../../elasticsearch-transport/lib', __FILE__) << File.expand_path('../test', __FILE__)
      require 'elasticsearch/extensions/test/cluster'
      Elasticsearch::Extensions::Test::Cluster.start
    end

    desc "Stop Elasticsearch nodes for tests"
    task :stop do
      $LOAD_PATH << File.expand_path('../../elasticsearch-transport/lib', __FILE__) << File.expand_path('../test', __FILE__)
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

require 'cane/rake_task'
Cane::RakeTask.new(:quality) do |cane|
  cane.abc_max = 15
  cane.no_style = true
end
