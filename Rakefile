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

import 'rake_tasks/elasticsearch_tasks.rake'
import 'rake_tasks/test_tasks.rake'
import 'rake_tasks/doc_generator.rake'
import 'rake_tasks/docker_tasks.rake'
import 'profile/benchmarking/benchmarking_tasks.rake'
require 'pathname'

CURRENT_PATH = Pathname(File.expand_path(__dir__))
SUBPROJECTS = [
  'elasticsearch',
  'elasticsearch-transport',
  'elasticsearch-dsl',
  'elasticsearch-api',
  'elasticsearch-extensions',
  'elasticsearch-xpack'
].freeze

RELEASE_TOGETHER = [
  'elasticsearch',
  'elasticsearch-transport',
  'elasticsearch-api',
  'elasticsearch-xpack'
].freeze

CERT_DIR = ENV['CERT_DIR'] || '.ci/certs'

# Import build task after setting constants:
import 'rake_tasks/build_tasks.rake'

def admin_client
  $admin_client ||= begin
    transport_options = {}
    test_suite = ENV['TEST_SUITE'].freeze

    if (hosts = ENV['TEST_ES_SERVER'] || ENV['ELASTICSEARCH_HOSTS'])
      split_hosts = hosts.split(',').map do |host|
        /(http\:\/\/)?\S+/.match(host)
      end
      uri = URI.parse(split_hosts.first[0])
    end

    if test_suite == 'xpack'
      transport_options.merge!(
        ssl: {
          verify: false,
          ca_path: CERT_DIR
        }
      )

      password = ENV['ELASTIC_PASSWORD']
      user     = ENV['ELASTIC_USER'] || 'elastic'
      url      = "https://#{user}:#{password}@#{uri.host}:#{uri.port}"
    else
      url = "http://#{uri&.host || 'localhost'}:#{uri&.port || 9200}"
    end
    puts "Elasticsearch Client url: #{url}"
    Elasticsearch::Client.new(host: url, transport_options: transport_options)
  end
end

# TODO: Figure out "bundle exec or not"
# subprojects.each { |project| $LOAD_PATH.unshift CURRENT_PATH.join(project, "lib").to_s }

task :default do
  system 'rake --tasks'
end

desc 'Display information about subprojects'
task :subprojects do
  puts '-' * 80
  SUBPROJECTS.each do |project|
    commit  = `git log --pretty=format:'%h %ar: %s' -1 #{project}`
    version = Gem::Specification::load(CURRENT_PATH.join(project, "#{project}.gemspec").to_s).version.to_s
    puts "#{version}".ljust(10) +
         "| \e[1m#{project.ljust(SUBPROJECTS.map {|s| s.length}.max)}\e[0m | #{commit[ 0..80]}..."
  end
end

desc 'Alias for `bundle:install`'
task bundle: 'bundle:install'

namespace :bundle do
  desc 'Run `bundle install` in all subprojects'
  task :install do
    SUBPROJECTS.each do |project|
      puts '-' * 80
      sh "cd #{CURRENT_PATH.join(project)} && unset BUNDLE_GEMFILE && bundle install"
      puts
    end
  end

  desc 'Remove Gemfile.lock in all subprojects'
  task :clean do
    SUBPROJECTS.each do |project|
      sh "rm -f #{CURRENT_PATH.join(project)}/Gemfile.lock"
    end
  end
end

desc 'Generate documentation for all subprojects'
task :doc do
  SUBPROJECTS.each do |project|
    sh "cd #{CURRENT_PATH.join(project)} && rake doc"
    puts '-' * 80
  end
end

desc 'Release all subprojects to Rubygems'
task :release do
  RELEASE_TOGETHER.each do |project|
    next if project == 'elasticsearch-extensions'

    sh "cd #{CURRENT_PATH.join(project)} && rake release"
    puts '-' * 80
  end
end

desc <<-DESC
  Update Rubygems versions in version.rb and *.gemspec files

  Example:

      $ rake update_version[5.0.0,5.0.1]
DESC
task :update_version, :old, :new do |_, args|
  require 'ansi'

  puts '[!!!] Required argument [old] missing'.ansi(:red) unless args[:old]
  puts '[!!!] Required argument [new] missing'.ansi(:red) unless args[:new]

  files = Dir['**/**/version.rb','**/**/*.gemspec']

  longest_line = files.map(&:size).max

  puts"\n", '= FILES '.ansi(:faint) + ('='*92).ansi(:faint), "\n"

  files.each do |file|
    begin
      content = File.read(file)
      if content.match Regexp.new(args[:old])
        content.gsub! Regexp.new(args[:old]), args[:new]
        puts "+ [#{file}]".ansi(:green).ljust(longest_line+20) + " [#{args[:old]}] -> [#{args[:new]}]".ansi(:green,:bold)
        File.open(file, 'w') { |f| f.puts content }
      else
        puts "- [#{file}]".ansi(:yellow).ljust(longest_line+20) + " -".ansi(:faint,:strike)
      end
    rescue Exception => e
      puts "[!!!] #{e.class} : #{e.message}".ansi(:red,:bold)
      raise e
    end
  end

  puts "\n\n", '= CHANGELOG '.ansi(:faint) + ('='*88).ansi(:faint), "\n"

  log = `git --no-pager log --reverse --no-color --pretty='* %s' HEAD --not v#{args[:old]} elasticsearch*`.split("\n")

  puts log.join("\n")

  log_entries = {}
  log_entries[:client] = log.select { |l| l =~ /\[CLIENT\]/ }
  log_entries[:api] = log.select { |l| l =~ /\[API\]/ }
  log_entries[:dsl] = log.select { |l| l =~ /\[DSL\]/ }
  log_entries[:ext] = log.select { |l| l =~ /\[EXT\]/ }
  log_entries[:xpack] = log.select { |l| l =~ /\[XPACK\]/ }

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
    changelog_update << "### EXT:#{args[:new]}\n\n"
    changelog_update << log_entries[:ext]
                          .map { |l| l.gsub /\[EXT\] /, '' }
                          .map { |l| "#{l}" }
                          .join("\n")
    changelog_update << "\n\n"
  end

  unless log_entries[:xpack].empty?
    changelog_update << "### XPACK\n\n"
    changelog_update << log_entries[:xpack]
                            .map { |l| l.gsub /\[XPACK\] /, '' }
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

  puts "\n\n", '= COMMIT '.ansi(:faint) + ('='*91).ansi(:faint), "\n"

  puts  'git add CHANGELOG.md elasticsearch*',
        "git commit --verbose --message='Release #{args[:new]}' --edit",
        'rake release',
        ''
end
