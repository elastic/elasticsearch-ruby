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
require_relative '../elasticsearch/lib/elasticsearch/version'
require 'elasticsearch-transport'

namespace :unified_release do
  desc 'Build gem releases and snapshots'
  task :assemble, [:version, :output_dir] do |_, args|
    @zip_filename = "elasticsearch-ruby-#{args[:version]}"
    @version = if args[:version].match? '-SNAPSHOT'
                 args[:version].gsub('-SNAPSHOT', ".#{Time.now.strftime('%Y%m%d%H%M%S')}-SNAPSHOT")
               else
                 args[:version]
               end

    Rake::Task['update_version'].invoke(Elasticsearch::VERSION, @version) unless @version == Elasticsearch::VERSION

    build_gems(args[:output_dir])
    create_zip_file(args[:output_dir])
  end

  def build_gems(output_dir)
    raise ArgumentError, 'You must specify an output dir' unless output_dir

    # Create dir if it doesn't exist
    dir = CURRENT_PATH.join(output_dir).to_s
    FileUtils.mkdir_p(dir) unless File.exist?(dir)

    RELEASE_TOGETHER.each do |gem|
      puts '-' * 80
      puts "Building #{gem} v#{@version} to #{output_dir}"
      sh "cd #{CURRENT_PATH.join(gem)} " \
         "&& gem build --silent -o #{gem}-#{@version}.gem && " \
         "mv *.gem #{CURRENT_PATH.join(output_dir)}"
    end
    puts '-' * 80
  end

  def create_zip_file(output_dir)
    sh "cd #{CURRENT_PATH.join(output_dir)} && " \
       "zip -r #{@zip_filename}.zip * " \
  end

  desc <<-DESC
  Update Rubygems versions in version.rb and *.gemspec files

  Example:

      $ rake unified_release:bump[42.0.0]
  DESC
  task :bump, :version do |_, args|
    abort('[!] Required argument [version] missing') unless (version = args[:version])

    branch = `git branch --show-current`.gsub("\n",'')
    branch_name = "bump_#{branch}_to_#{version}"
    # `git checkout #{branch}`
    puts `git checkout -b #{branch_name}`
    bump_version(version)

    puts `git add .`
    puts `git commit -m "Bumps to version ${version}"`
    puts `git push --set-upstream origin #{branch_name}`

    token = ENV['CLIENTS_GITHUB_TOKEN'] || File.read(File.expand_path('~/.elastic/github.token'))

    client = Elasticsearch::Transport::Client.new(host: 'https://api.github.com/')
    headers = {
      'Accept' => 'application/vnd.github.v3+json',
      'Authorization' => "token #{token}"
    }
    body = {
      title: "Bumps #{branch}",
      maintainer_can_modify: true,
      head: branch_name,
      base: branch
    }

    require 'byebug'; byebug

    pull_request = client.perform_request('POST', "/repos/elastic/elasticsearch-ruby/pulls", {}, body, headers)

    begin
      pull_request = client.perform_request('POST', "/repos/elastic/elasticsearch-ruby/pulls", {}, body, headers)
      1
    rescue StandardError => e
      require 'byebug'; byebug
      1
    end
  end

  def bump_version(version)
    files = ['elasticsearch/elasticsearch.gemspec']
    RELEASE_TOGETHER.each do |gem|
      files << Dir["./#{gem}/**/**/version.rb"]
    end

    version_regexp = Regexp.new(/VERSION = ("|'([0-9.]+(-SNAPSHOT)?)'|")/)
    gemspec_regexp = Regexp.new(/('elasticsearch-transport'|'elasticsearch-api'),\s+'([0-9.]+)'/)

    files.flatten.each do |file|
      content = File.read(file)
      regexp = file.match?('gemspec') ? gemspec_regexp : version_regexp

      if (match = content.match(regexp))
        old_version = match[2]
        content.gsub!(old_version, version)
        puts "[#{old_version}] -> [#{version}] in #{file.gsub('./','')}"
        File.open(file, 'w') { |f| f.puts content }
      else
        puts "- [#{file}]".ljust(longest_line+20) + " -"
      end
    rescue StandardError => e
      abort "[!!!] #{e.class} : #{e.message}"
    end
  end
end
