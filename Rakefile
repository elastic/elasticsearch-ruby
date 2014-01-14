require 'pathname'

subprojects = %w| elasticsearch elasticsearch-transport elasticsearch-api elasticsearch-extensions |
__current__ = Pathname( File.expand_path('..', __FILE__) )

# TODO: Figure out "bundle exec or not"
# subprojects.each { |project| $LOAD_PATH.unshift __current__.join(project, "lib").to_s }

task :default do
  system "rake --tasks"
end

task :subprojects do
  puts '-'*80
  subprojects.each do |project|
    commit  = `git log --pretty=format:'%h %ar: %s' -1 #{project}`
    version =  Gem::Specification::load(__current__.join(project, "#{project}.gemspec").to_s).version.to_s
    puts "[#{version}] \e[1m#{project.ljust(subprojects.map {|s| s.length}.max)}\e[0m | #{commit[ 0..80]}..."
  end
end

desc "Alias for `bundle:install`"
task :bundle => 'bundle:install'

namespace :bundle do
  desc "Run `bundle install` in all subprojects"
  task :install do
    puts '-'*80
    sh "bundle install --gemfile #{__current__}/Gemfile"
    puts
    subprojects.each do |project|
      puts '-'*80
      sh "bundle install --gemfile #{__current__.join(project)}/Gemfile"
      puts
    end
  end

  desc "Remove Gemfile.lock in all subprojects"
  task :clean do
    sh "rm -f Gemfile.lock"
    subprojects.each do |project|
      sh "rm -f #{__current__.join(project)}/Gemfile.lock"
    end
  end
end


task 'es:update'  => 'elasticsearch:update'
task 'es:build'   => 'elasticsearch:build'
task 'es:status'  => 'elasticsearch:status'
task 'es:changes' => 'elasticsearch:changes'

namespace :elasticsearch do
  desc "Update the submodule with Elasticsearch core repository"
  task :update do
    sh "git submodule foreach git reset --hard"
    puts
    sh "git --git-dir=#{__current__.join('support/elasticsearch/.git')} --work-tree=#{__current__.join('support/elasticsearch')} fetch origin --verbose"
    begin
      puts %x[git --git-dir=#{__current__.join('support/elasticsearch/.git')} --work-tree=#{__current__.join('support/elasticsearch')} pull --verbose]
    rescue Exception => @exception
      @failed = true
    end

    if @failed || !$?.success?
      STDERR.puts "", "[!] Error while pulling. #{@exception}"
    end

    puts "\n", "CHANGES:", '-'*80
    sh "git --git-dir=#{__current__.join('support/elasticsearch/.git')} --work-tree=#{__current__.join('support/elasticsearch')} log --oneline ORIG_HEAD..HEAD | cat", :verbose => false
  end

  desc "Build Elasticsearch for the specified branch (master by default)"
  task :build, :branch do |task, args|
    branch = args[:branch] || 'master'
    current_branch = `git --git-dir=#{__current__.join('support/elasticsearch/.git')} --work-tree=#{__current__.join('support/elasticsearch')} branch --no-color`.split("\n").select { |b| b =~ /^\*/ }.first.gsub(/^\*\s*/, '')
    begin
      sh <<-CODE
        mkdir -p #{__current__.join('tmp/builds')} && \
        cd #{__current__.join('support/elasticsearch')} && \
        git checkout #{branch} && \
        mvn clean package -DskipTests && \
        echo "Built: `ls target/releases/elasticsearch-*.tar.gz`" && \
        tar xvf target/releases/elasticsearch-*.tar.gz -C #{__current__.join('tmp/builds')}
      CODE

      puts "", '-'*80, "", "Builds:"
      Dir.entries(__current__.join('tmp/builds')).reject { |f| f =~ /^\./ }.each do |build|
        puts "* #{build}"
      end
    end
  end

  desc "Display the last commit in all local branches"
  task :status do
    branches = `git --git-dir=#{__current__.join('support/elasticsearch/.git')} --work-tree=#{__current__.join('support/elasticsearch')} branch --no-color`.gsub(/\* /, '').split("\n").map { |s| s.strip }
    branches.each do |branch|
      puts "[\e[1m#{branch}\e[0m]"
      sh "git --git-dir=#{__current__.join('support/elasticsearch/.git')} --work-tree=#{__current__.join('support/elasticsearch')} log --pretty=format:'\e[2m%h\e[0m \e[1m%cr\e[0m [%an %ar] %s' -1 #{branch}", :verbose => false
      puts
    end
  end

  desc "Display the history of the 'rest-api-spec' repo"
  task :changes do
    STDERR.puts "Log: #{__current__.join('support/elasticsearch')}/rest-api-spec", ""
    sh "git --git-dir=#{__current__.join('support/elasticsearch/.git')} --work-tree=#{__current__.join('support/elasticsearch')} log --pretty=format:'%C(yellow)%h%Creset %s \e[2m[%ar by %an]\e[0m' -- rest-api-spec", :verbose => false
  end
end

namespace :test do
  task :bundle => 'bundle:install'

  desc "Run unit tests in all subprojects"
  task :unit do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      puts '-'*80
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:unit"
      puts "\n"
    end
    Rake::Task['test:coveralls'].invoke if ENV['CI'] && defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  end

  desc "Run integration tests in all subprojects"
  task :integration do
    Rake::Task['elasticsearch:update'].invoke
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      puts '-'*80
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:integration"
      puts "\n"
    end
    Rake::Task['test:coveralls'].invoke if ENV['CI'] && defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
  end

  desc "Run all tests in all subprojects"
  task :all do
    Rake::Task['test:ci_reporter'].invoke if ENV['CI']
    subprojects.each do |project|
      puts '-'*80
      sh "cd #{__current__.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:all"
      puts "\n"
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
