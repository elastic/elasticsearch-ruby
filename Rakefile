require 'pathname'

subprojects = %w| elasticsearch elasticsearch-transport elasticsearch-api elasticsearch-extensions |
__current__ = Pathname( File.expand_path('..', __FILE__) )

# TODO: Figure out "bundle exec or not"
# subprojects.each { |project| $LOAD_PATH.unshift __current__.join(project, "lib").to_s }

task :default do
  system "rake --tasks"
end

desc "Display information about subprojects"
task :subprojects do
  puts '-'*80
  subprojects.each do |project|
    commit  = `git log --pretty=format:'%h %ar: %s' -1 #{project}`
    version =  Gem::Specification::load(__current__.join(project, "#{project}.gemspec").to_s).version.to_s
    puts "#{version}".ljust(10) +
         "| \e[1m#{project.ljust(subprojects.map {|s| s.length}.max)}\e[0m | #{commit[ 0..80]}..."
  end
end

desc "Setup the project"
task :setup do
  unless File.exists?('./tmp/elasticsearch')
    sh "git clone https://github.com/elasticsearch/elasticsearch.git tmp/elasticsearch"
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

namespace :elasticsearch do
  desc "Update the submodule with Elasticsearch core repository"
  task :update do
    sh "git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} fetch origin --verbose"
    begin
      puts %x[git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} pull --verbose]
    rescue Exception => @exception
      @failed = true
    end

    if @failed || !$?.success?
      STDERR.puts "", "[!] Error while pulling -- #{@exception}"
    end

    puts "\n", "CHANGES:", '-'*80
    sh "git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} log --oneline ORIG_HEAD..HEAD | cat", :verbose => false
  end

  desc <<-DESC
    Build Elasticsearch for the specified branch ('origin/master' by default)"

    Build a specific branch:

        $ rake elasticsearch:build[origin/1.x]

    The task will execute `git fetch` to synchronize remote branches.
  DESC
  task :build, :branch do |task, args|
    Rake::Task['elasticsearch:status'].invoke
    puts '-'*80

    branch = args[:branch] || 'origin/master'
    current_branch = `git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} branch --no-color`.split("\n").select { |b| b =~ /^\*/ }.first.gsub(/^\*\s*/, '')
    begin
      sh <<-CODE
        mkdir -p #{__current__.join('tmp/builds')};
        rm -rf '#{__current__.join('tmp/elasticsearch/target')}';
        cd #{__current__.join('tmp/elasticsearch')} && git fetch origin --quiet;
        cd #{__current__.join('tmp/elasticsearch')} && git checkout #{branch};
        cd #{__current__.join('tmp/elasticsearch')} && mvn clean package -DskipTests;
        build=`ls #{__current__.join('tmp/elasticsearch/target/releases/elasticsearch-*.tar.gz')} | xargs -0 basename | sed s/\.tar\.gz//` && \
        rm -rf "#{__current__.join('tmp/builds')}/$build";
        tar xvf target/releases/elasticsearch-*.tar.gz -C #{__current__.join('tmp/builds')};
        echo; echo; echo "Built: $build"
      CODE
    end

    puts "", '-'*80, ""
    Rake::Task['elasticsearch:builds'].invoke
  end

  desc "Display the info for all branches in the Elasticsearch submodule"
  task :status do
    sh "git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} branch -v -v", :verbose => false
  end

  desc "Display the list of builds"
  task :builds do
    puts "Builds:"
      Dir.entries(__current__.join('tmp/builds')).reject { |f| f =~ /^\./ }.each do |build|
        puts "* #{build}"
      end
  end

  desc "Display the history of the 'rest-api-spec' repo"
  task :changes do
    STDERR.puts "Log: #{__current__.join('tmp/elasticsearch')}/rest-api-spec", ""
    sh "git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} log --pretty=format:'%C(yellow)%h%Creset %s \e[2m[%ar by %an]\e[0m' -- rest-api-spec", :verbose => false
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
    next if project == 'elasticsearch-extensions'
    sh "cd #{__current__.join(project)} && rake release"
    puts '-'*80
  end
end
