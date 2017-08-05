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
  unless File.exist?('./tmp/elasticsearch')
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

    gitref = args[:branch] || 'origin/master'
    es_version = gitref.gsub(/^v|origin\/(\d\.+)/, '\1').to_f

    current_branch = `git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} branch --no-color`.split("\n").select { |b| b =~ /^\*/ }.first.gsub(/^\*\s*/, '')

    STDOUT.puts "Building version [#{es_version}] from [#{gitref}]:", ""

    case es_version
      when 0.0, 5..1000
        path_to_build   = __current__.join('tmp/elasticsearch/distribution/tar/build/distributions/elasticsearch-*.tar.gz')
        build_command   = "cd #{__current__.join('tmp/elasticsearch/distribution/tar')} && gradle clean assemble;"
        extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{__current__.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{__current__.join('tmp/builds')};
        CODE
      when 1.8..4
        path_to_build   = __current__.join('tmp/elasticsearch/distribution/tar/target/releases/elasticsearch-*.tar.gz')
        build_command = "cd #{__current__.join('tmp/elasticsearch')} && MAVEN_OPTS=-Xmx1g mvn --projects core,distribution/tar clean package -DskipTests -Dskip.integ.tests;"
        extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{__current__.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{__current__.join('tmp/builds')};
        CODE
      when 0.1..1.7
        path_to_build   = __current__.join('tmp/elasticsearch/target/releases/elasticsearch-*.tar.gz')
        build_command = "cd #{__current__.join('tmp/elasticsearch')} && MAVEN_OPTS=-Xmx1g mvn clean package -DskipTests"
        extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{__current__.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{__current__.join('tmp/builds')};
        CODE
      else
        STDERR.puts "", "[!] Cannot determine a compatible version of the build (gitref: #{gitref}, es_version: #{es_version})"
        exit(1)
    end

    sh <<-CODE.gsub(/      /, '')
      mkdir -p #{__current__.join('tmp/builds')};
      rm -rf '#{__current__.join('tmp/elasticsearch/distribution/tar/target/')}';
      cd #{__current__.join('tmp/elasticsearch')} && git fetch origin --quiet;
      cd #{__current__.join('tmp/elasticsearch')} && git checkout #{gitref};
      #{build_command}
      #{extract_command}
      echo; echo; echo "Built: $build"
    CODE

    puts "", '-'*80, ""
    Rake::Task['elasticsearch:builds'].invoke
  end

  desc "Display the info for all branches in the Elasticsearch submodule"
  task :status do
    sh "git --git-dir=#{__current__.join('tmp/elasticsearch/.git')} --work-tree=#{__current__.join('tmp/elasticsearch')} branch -v -v", :verbose => false
  end

  desc "Display the list of builds"
  task :builds do
    system "mkdir -p #{__current__.join('tmp/builds')};"
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

desc <<-DESC
  Update Rubygems versions in version.rb and *.gemspec files

  Example:

      $ rake update_version[5.0.0,5.0.1]
DESC
task :update_version, :old, :new do |task, args|
  require 'ansi'

  puts "[!!!] Required argument [old] missing".ansi(:red) unless args[:old]
  puts "[!!!] Required argument [new] missing".ansi(:red) unless args[:new]

  files = Dir['**/**/version.rb','**/**/*.gemspec']

  longest_line = files.map { |f| f.size }.max

  puts "\n", "= FILES ".ansi(:faint) + ('='*92).ansi(:faint), "\n"

  files.each do |file|
    begin
      File.open(file, 'r+') do |f|
        content = f.read
        if content.match Regexp.new(args[:old])
          content.gsub! Regexp.new(args[:old]), args[:new]
          puts "+ [#{file}]".ansi(:green).ljust(longest_line+20) + " [#{args[:old]}] -> [#{args[:new]}]".ansi(:green,:bold)
          f.rewind
          f.write content
        else
          puts "- [#{file}]".ansi(:yellow).ljust(longest_line+20) + " -".ansi(:faint,:strike)
        end
      end
    rescue Exception => e
      puts "[!!!] #{e.class} : #{e.message}".ansi(:red,:bold)
      raise e
    end
  end

  puts "\n\n", "= CHANGELOG ".ansi(:faint) + ('='*88).ansi(:faint), "\n"

  log = `git --no-pager log --reverse --no-color --pretty='* %s' HEAD --not v#{args[:old]} elasticsearch*`.split("\n")

  puts log.join("\n")

  log_entries = {}
  log_entries[:client] = log.select { |l| l =~ /\[CLIENT\]/ }
  log_entries[:api] = log.select { |l| l =~ /\[API\]/ }
  log_entries[:dsl] = log.select { |l| l =~ /\[DSL\]/ }
  log_entries[:ext] = log.select { |l| l =~ /\[EXT\]/ }

  changelog = File.read(File.open('CHANGELOG.md', 'r'))

  changelog_update = ''

  if log.any? { |l| l =~ /CLIENT|API|DSL/ }
    changelog_update << "## #{args[:new]}\n\n"
  end

  unless log_entries[:client].empty?
    changelog_update << "### Client\n\n"
    changelog_update << log_entries[:client]
                          .map { |l| l.gsub /\[CLIENT\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:api].empty?
    changelog_update << "### API\n\n"
    changelog_update << log_entries[:api]
                          .map { |l| l.gsub /\[API\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:dsl].empty?
    changelog_update << "### DSL\n\n"
    changelog_update << log_entries[:dsl]
                          .map { |l| l.gsub /\[DSL\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:client].empty?
    changelog_update << "## EXT:#{args[:new]}\n\n"
    changelog_update << log_entries[:ext]
                          .map { |l| l.gsub /\[EXT\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  File.open('CHANGELOG.md', 'w+') { |f| f.write changelog_update and f.write changelog }

  puts "\n\n", "= DIFF ".ansi(:faint) + ('='*93).ansi(:faint)

  diff = `git --no-pager diff --patch --word-diff=color --minimal elasticsearch*`.split("\n")

  puts diff
          .reject { |l| l =~ /^\e\[1mdiff \-\-git/ }
          .reject { |l| l =~ /^\e\[1mindex [a-z0-9]{7}/ }
          .reject { |l| l =~ /^\e\[1m\-\-\- i/ }
          .reject { |l| l =~ /^\e\[36m@@/ }
          .map    { |l| l =~ /^\e\[1m\+\+\+ w/ ? "\n#{l}   " + '-'*(104-l.size) : l }
          .join("\n")

  puts "\n\n", "= COMMIT ".ansi(:faint) + ('='*91).ansi(:faint), "\n"

  puts  "git add CHANGELOG.md elasticsearch*",
        "git commit --verbose --message='Release #{args[:new]}' --edit",
        "rake release"
        "\n"
end
