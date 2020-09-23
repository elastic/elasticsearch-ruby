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

ELASTICSEARCH_PATH = "#{CURRENT_PATH}/tmp/elasticsearch".freeze

desc 'Clone elasticsearch into the ./tmp directory'
task :setup do
  unless File.exist?('./tmp/elasticsearch')
    sh 'git clone https://github.com/elasticsearch/elasticsearch.git tmp/elasticsearch'
  end
end

namespace :elasticsearch do
  desc 'Wait for elasticsearch cluster to be in green state'
  task :wait_for_green do
    require 'elasticsearch'

    ready = nil
    5.times do |i|
      begin
        puts "Attempting to wait for green status: #{i + 1}"
        if admin_client.cluster.health(wait_for_status: 'green', timeout: '50s')
          ready = true
          break
        end
      rescue Elasticsearch::Transport::Transport::Errors::RequestTimeout => e
        puts "Couldn't confirm green status.\n#{e.inspect}."
      rescue Faraday::ConnectionFailed => e
        puts "Couldn't connect to Elasticsearch.\n#{e.inspect}."
        sleep(30)
      end
    end
    unless ready
      puts "Couldn't connect to Elasticsearch, aborting program."
      exit(1)
    end
  end

  desc 'Update the submodule with Elasticsearch core repository'
  task update: :setup do
    sh "git --git-dir=#{CURRENT_PATH.join('tmp/elasticsearch/.git')} --work-tree=#{CURRENT_PATH.join('tmp/elasticsearch')} fetch origin --quiet"
    begin
      %x[git --git-dir=#{CURRENT_PATH.join('tmp/elasticsearch/.git')} --work-tree=#{CURRENT_PATH.join('tmp/elasticsearch')} pull]
    rescue Exception => @e
      @failed = true
    end

    STDERR.puts '', "[!] Error while pulling -- #{@e}" if @failed || !$?.success?

    puts "\n", "CHANGES:", '-' * 80
    sh "git --git-dir=#{CURRENT_PATH.join('tmp/elasticsearch/.git')} --work-tree=#{CURRENT_PATH.join('tmp/elasticsearch')} log --oneline ORIG_HEAD..HEAD | cat", :verbose => false
  end

  desc <<-DESC
    Build Elasticsearch for the specified branch ('origin/master' by default)

    Build a specific branch:

        $ rake elasticsearch:build[origin/1.x]

    The task will execute `git fetch` to synchronize remote branches.
  DESC
  task :build, :branch do |task, args|
    Rake::Task['elasticsearch:status'].invoke
    puts '-' * 80

    gitref = args[:branch] || 'origin/master'
    es_version = gitref.gsub(/^v|origin\/(\d\.+)/, '\1').to_f

    current_branch = `git --git-dir=#{CURRENT_PATH.join('tmp/elasticsearch/.git')} --work-tree=#{CURRENT_PATH.join('tmp/elasticsearch')} branch --no-color`.split("\n").select { |b| b =~ /^\*/ }.first.gsub(/^\*\s*/, '')

    STDOUT.puts "Building version [#{es_version}] from [#{gitref}]:", ""

    case es_version
    when 0.0, 7.0, 8.0
      path_to_build = CURRENT_PATH.join('tmp/elasticsearch/distribution/docker/build/docker/elasticsearch-*.tar.gz')
      build_command = "cd #{CURRENT_PATH.join('tmp/elasticsearch')} && ./gradlew assemble;"

      extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | awk '{print $NF}' | awk -F '/' '{print $NF}' | sed s/\.tar\.gz//`
          if [ $build ]; then
            rm -rf "#{CURRENT_PATH.join('tmp/builds')}/$build";
            echo "cool"
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{CURRENT_PATH.join('tmp/builds')};
      CODE
    when 5..1000
      path_to_build = CURRENT_PATH.join('tmp/elasticsearch/distribution/tar/build/distributions/elasticsearch-*.tar.gz')
      build_command = "cd #{CURRENT_PATH.join('tmp/elasticsearch/distribution/tar')} && gradle clean assemble;"
      extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{CURRENT_PATH.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{CURRENT_PATH.join('tmp/builds')};
      CODE
    when 1.8..4
      path_to_build   = CURRENT_PATH.join('tmp/elasticsearch/distribution/tar/target/releases/elasticsearch-*.tar.gz')
      build_command = "cd #{CURRENT_PATH.join('tmp/elasticsearch')} && MAVEN_OPTS=-Xmx1g mvn --projects core,distribution/tar clean package -DskipTests -Dskip.integ.tests;"
      extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [[ $build ]]; then
            rm -rf "#{CURRENT_PATH.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{CURRENT_PATH.join('tmp/builds')};
      CODE
    when 0.1..1.7
      path_to_build   = CURRENT_PATH.join('tmp/elasticsearch/target/releases/elasticsearch-*.tar.gz')
      build_command = "cd #{CURRENT_PATH.join('tmp/elasticsearch')} && MAVEN_OPTS=-Xmx1g mvn clean package -DskipTests"
      extract_command = <<-CODE.gsub(/          /, '')
          build=`ls #{path_to_build} | xargs -0 basename | sed s/\.tar\.gz//`
          if [ $build ]; then
            rm -rf "#{CURRENT_PATH.join('tmp/builds')}/$build";
          else
            echo "Cannot determine build, exiting..."
            exit 1
          fi
          tar xvf #{path_to_build} -C #{CURRENT_PATH.join('tmp/builds')};
      CODE
    else
      STDERR.puts "", "[!] Cannot determine a compatible version of the build (gitref: #{gitref}, es_version: #{es_version})"
      exit(1)
    end

    sh <<-CODE.gsub(/      /, '')
      mkdir -p #{CURRENT_PATH.join('tmp/builds')};
      rm -rf '#{CURRENT_PATH.join('tmp/elasticsearch/distribution/tar/target/')}';
      cd #{CURRENT_PATH.join('tmp/elasticsearch')} && git fetch origin --quiet;
      cd #{CURRENT_PATH.join('tmp/elasticsearch')} && git checkout #{gitref};
      #{build_command}
      #{extract_command}
      echo; echo; echo "Built: $build"
    CODE

    puts '', '-' * 80, ''
    Rake::Task['elasticsearch:builds'].invoke
  end

  desc "Display the info for all branches in the Elasticsearch submodule"
  task :status do
    sh "git --git-dir=#{CURRENT_PATH.join('tmp/elasticsearch/.git')} --work-tree=#{CURRENT_PATH.join('tmp/elasticsearch')} branch -v -v", :verbose => false
  end

  desc "Display the list of builds"
  task :builds do
    system "mkdir -p #{CURRENT_PATH.join('tmp/builds')};"
    puts "Builds:"
    Dir.entries(CURRENT_PATH.join('tmp/builds')).reject { |f| f =~ /^\./ }.each do |build|
      puts "* #{build}"
    end
  end

  desc "Display the history of the 'rest-api-spec' repo"
  task :changes do
    STDERR.puts "Log: #{CURRENT_PATH.join('tmp/elasticsearch')}/rest-api-spec", ""
    sh "git --git-dir=#{CURRENT_PATH.join('tmp/elasticsearch/.git')} --work-tree=#{CURRENT_PATH.join('tmp/elasticsearch')} log --pretty=format:'%C(yellow)%h%Creset %s \e[2m[%ar by %an]\e[0m' -- rest-api-spec", :verbose => false
  end

  desc "Checkout the build hash from the running Elasticsearch server"
  task :checkout_build do
    require 'elasticsearch'

    branches = `git --git-dir=#{ELASTICSEARCH_PATH}/.git --work-tree=#{ELASTICSEARCH_PATH} branch --no-color`
    current_branch = branches.
        split("\n").
        select { |b| b =~ /^\*/ }.
        reject { |b| b =~ /no branch|detached/ }.
        map    { |b| b.gsub(/^\*\s*/, '') }.
        first

    unless current_branch
      STDERR.puts "[!] Unable to determine current branch, defaulting to 'master'"
      current_branch = 'master'
    end

    es_version_info = admin_client.info['version']
    unless build_hash = es_version_info['build_hash']
      STDERR.puts "[!] Cannot determine checkout build hash -- server not running"
      exit(1)
    end

    name = ENV['CI'] ? build_hash : "[\e[1m#{build_hash}\e[0m]"
    STDERR.puts '-'*80, "YAML tests: Switching to #{name} from #{current_branch}", '-'*80
    git_specs("checkout #{build_hash} --force --quiet")
  end
end

def git_specs(command, options={})
  sh "git --git-dir=#{ELASTICSEARCH_PATH}/.git --work-tree=#{ELASTICSEARCH_PATH} #{command}", options
end
