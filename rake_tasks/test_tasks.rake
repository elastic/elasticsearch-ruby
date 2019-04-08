UNIT_TESTED_PROJECTS = [ 'elasticsearch',
                         'elasticsearch-transport',
                         'elasticsearch-dsl',
                         'elasticsearch-api',
                         'elasticsearch-extensions' ].freeze

INTEGRATION_TESTED_PROJECTS = (UNIT_TESTED_PROJECTS - ['elasticsearch-api']).freeze

namespace :test do
  task :bundle => 'bundle:install'

  desc "Run all tests in all subprojects"
  task :client => [ :unit, :integration ]

  desc "Run unit tests in all subprojects"
  task :unit do
    UNIT_TESTED_PROJECTS.each do |project|
      puts '-'*80
      sh "cd #{CURRENT_PATH.join(project)} && unset BUNDLE_GEMFILE && unset BUNDLE_PATH && unset BUNDLE_BIN && bundle exec rake test:unit"
      puts "\n"
    end
  end

  desc "Run integration tests in all subprojects"
  task :integration do
    INTEGRATION_TESTED_PROJECTS.each do |project|
      puts '-'*80
      sh "cd #{CURRENT_PATH.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:integration"
      puts "\n"
    end
  end

  desc "Run rest api tests"
  task :rest_api => 'elasticsearch:update' do
    puts '-' * 80
    sh "cd #{CURRENT_PATH.join('elasticsearch-api')} && unset BUNDLE_GEMFILE && bundle exec rake test:integration"
    puts "\n"
  end

  desc "Run security (Platinum) rest api yaml tests"
  task :security => 'elasticsearch:update' do
    Rake::Task['elasticsearch:wait_for_green'].invoke
    Rake::Task['elasticsearch:checkout_build'].invoke
    puts '-' * 80
    sh "cd #{CURRENT_PATH.join('elasticsearch-xpack')} && unset BUNDLE_GEMFILE && bundle exec rake test:rest_api"
    puts "\n"
  end

  namespace :cluster do
    desc "Start Elasticsearch nodes for tests"
    task :start do
      require 'elasticsearch/extensions/test/cluster'
      Elasticsearch::Extensions::Test::Cluster.start
    end

    desc "Stop Elasticsearch nodes for tests"
    task :stop do
      require 'elasticsearch/extensions/test/cluster'
      Elasticsearch::Extensions::Test::Cluster.stop
    end

    task :status do
      require 'elasticsearch/extensions/test/cluster'
      (puts "\e[31m[!] Test cluster not running\e[0m"; exit(1)) unless Elasticsearch::Extensions::Test::Cluster.running?
      Elasticsearch::Extensions::Test::Cluster.__print_cluster_info(ENV['TEST_CLUSTER_PORT'] || 9250)
    end
  end
end
