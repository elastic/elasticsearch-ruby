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

require 'fileutils'
require 'yaml'
require_relative '../elasticsearch/lib/elasticsearch/version'

namespace :automation do
  desc 'Build gem releases and snapshots'
  task :build_gems do
    output_dir = File.expand_path("#{__dir__}/../build")
    dir = CURRENT_PATH.join(output_dir).to_s
    FileUtils.mkdir_p(dir) unless File.exist?(dir)
    version = Elasticsearch::VERSION
    RELEASE_TOGETHER.each do |gem|
      puts '-' * 80
      puts "Building #{gem} v#{version} to #{output_dir}"
      sh "cd #{CURRENT_PATH.join(gem)} " \
         "&& gem build --silent -o #{gem}-#{version}.gem && " \
         "mv *.gem #{CURRENT_PATH.join(output_dir)}"
    end
    puts '-' * 80
  end

  desc 'Generate API code'
  task :codegen do
    path = File.expand_path('../elasticsearch-api/', __dir__)
    branch = YAML.load_file(File.expand_path("#{__dir__}/../.buildkite/pipeline.yml"))['steps'].first['env']['ES_YAML_TESTS_BRANCH']
    unless File.exist?(File.expand_path('elastic-client-generator-ruby', __dir__))
      sh "git clone https://#{ENV['CLIENTS_GITHUB_TOKEN']}@github.com/elastic/elastic-client-generator-ruby.git "
    end

    sh "export ES_RUBY_CLIENT_PATH=#{path} " \
       ' && cd elastic-client-generator-ruby ' \
       ' && sudo bundle install ' \
       " && bundle exec rake update[#{branch}]" \
       ' && bundle exec rake gen_es' \
       ' && cd ../../ ' \
       ' && rm -rf elastic-client-generator-ruby '
  end

  desc <<-DESC
  Update Rubygems versions in version.rb and *.gemspec files

  Example:

      $ rake automation:bump[42.0.0]
  DESC
  task :bump, :version do |_, args|
    abort('[!] Required argument [version] missing') unless (version = args[:version])
    files = ['elasticsearch/elasticsearch.gemspec'] + RELEASE_TOGETHER.map { |gem| Dir["./#{gem}/**/**/version.rb"] }
    version_regexp = Regexp.new(/VERSION = ("|'([0-9.]+(-SNAPSHOT)?)'|")/)
    gemspec_regexp = Regexp.new(/'elasticsearch-api',\s+'([0-9x.]+)'/)

    files.flatten.each do |file|
      content = File.read(file)
      is_gemspec_file = file.match?('gemspec')
      regexp = if is_gemspec_file
                 gemspec_regexp
               else
                 version_regexp
               end

      if (match = content.match(regexp))
        old_version = match[1]
        if is_gemspec_file
          content.gsub!("'elasticsearch-api', '#{old_version}'", "'elasticsearch-api', '#{version}'")
        else
          content.gsub!(old_version, "'#{version}'")
        end
      else
        match = content.match(version_regexp)
        old_version = match[1]
        content.gsub!(old_version, "'#{version}'")
      end
      puts "[#{old_version}] -> [#{version}] in #{file.gsub('./', '')}"
      File.open(file, 'w') { |f| f.puts content }
    end
  rescue StandardError => e
    raise "[!!!] #{e.class} : #{e.message}"
  end

  desc <<-DESC
  Bump the version in test matrixes:
  - .github/workflows
  - .buildkite/pipeline.yml

  Example:

      $ rake automation:bump_matrix[42.0.0]
  DESC
  task :bumpmatrix, :version do |_, args|
    abort('[!] Required argument [version] missing') unless (version = args[:version])
    gh_actions = Dir.glob(File.expand_path('../.github/workflows/*.yml', __dir__))

    files = gh_actions + ['.buildkite/pipeline.yml']
    regexp = Regexp.new(/([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}?+(-SNAPSHOT)?)/)
    files.each do |file|
      content = File.read(file)
      if file == '.buildkite/pipeline.yml'
        require 'yaml'
        yaml = YAML.safe_load(content)
        yaml_tests_branch = yaml['steps'][0]['env']['ES_YAML_TESTS_BRANCH']

        if yaml_tests_branch == 'main'
          old = content.match(/STACK_VERSION: (.*)/)[1]
          new = "STACK_VERSION: #{version}"
          content.gsub!(new, old)
        else
          branch = version.match(/([0-9]+\.[0-9]+)\.[0-9]+.*/)[1]
          content.gsub!(yaml_tests_branch, branch)
        end
        puts "[#{yaml_tests_branch}] -> [#{branch}] in #{file.gsub('./', '')}"
      end
      match = content.match(regexp)
      next if match.nil?

      old_version = match[1]
      next if old_version == args[:version]

      content.gsub!(old_version, args[:version])
      puts "[#{old_version}] -> [#{version}] in #{file.gsub('./', '')}"
      File.open(file, 'w') { |f| f.puts content }
    end
  end

  desc 'Show current client version'
  task :version do
    puts Elasticsearch::VERSION
  end
end
