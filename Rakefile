require 'pathname'

subprojects = %w| elasticsearch elasticsearch-transport elasticsearch-api elasticsearch-extensions |
__current__ = Pathname( File.expand_path('..', __FILE__) )

task :default do
  system "rake --tasks"
end

namespace :test do
  desc "Run `bundle install` in all subprojects"
  task :bundle do
    sh "bundle install --gemfile #{__current__}/Gemfile"
    subprojects.each do |project|
      sh "bundle install --gemfile #{__current__.join(project)}/Gemfile"
      puts '-'*80
    end
  end

  desc "Update the submodule with YAML tests to the latest master"
  task :update do
    sh "git submodule foreach git reset --hard"
    sh "git --git-dir=#{__current__.join('elasticsearch-api/spec/.git')} --work-tree=#{__current__.join('elasticsearch-api/spec/')} pull origin master"
  end

  desc "Run unit tests in all subprojects"
  task :unit do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:unit"
      puts '-'*80
    end
    Rake::Task['test:coveralls'].invoke if ENV['CI'] && defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  end

  desc "Run integration tests in all subprojects"
  task :integration => :update do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:integration"
      puts '-'*80
    end
    Rake::Task['test:coveralls'].invoke if ENV['CI'] && defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  end

  desc "Run all tests in all subprojects"
  task :all do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:all"
      puts '-'*80
    end
  end

  task :coveralls do
    require 'coveralls/rake/task'
    Coveralls::RakeTask.new
    Rake::Task['coveralls:push'].invoke
  end

  task :ci_reporter do
    ENV['CI_REPORTS'] ||= 'tmp/reports'
    if defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
      require 'ci/reporter/rake/test_unit'
      Rake::Task['ci:setup:testunit'].invoke
    else
      require 'ci/reporter/rake/minitest'
      Rake::Task['ci:setup:minitest'].invoke
    end
  end

  namespace :server do
    desc "Start Elasticsearch nodes for tests"
    task :start do
      require File.expand_path('../elasticsearch-transport/lib/elasticsearch/transport', __FILE__)
      require File.expand_path('../elasticsearch-transport/lib/elasticsearch/transport/extensions/test_cluster', __FILE__)
      Elasticsearch::TestCluster.start
    end

    desc "Stop Elasticsearch nodes for tests"
    task :stop do
      require File.expand_path('../elasticsearch-transport/lib/elasticsearch/transport', __FILE__)
      require File.expand_path('../elasticsearch-transport/lib/elasticsearch/transport/extensions/test_cluster', __FILE__)
      Elasticsearch::TestCluster.stop
    end
  end
end

desc "Generate documentation for all subprojects"
task :doc do
  subprojects.each do |project|
    sh "cd #{__current__.join(project)} && rake doc"
    puts '-'*80
  end
end

desc "Release all subprojects to Rubygems"
task :release do
  subprojects.each do |project|
    sh "cd #{__current__.join(project)} && rake release"
    puts '-'*80
  end
end
