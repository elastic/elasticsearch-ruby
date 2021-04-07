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

UNIT_TESTED_PROJECTS = [
  'elasticsearch',
  'elasticsearch-transport',
  'elasticsearch-dsl',
  'elasticsearch-api',
  'elasticsearch-xpack'
].freeze

INTEGRATION_TESTED_PROJECTS = (UNIT_TESTED_PROJECTS - ['elasticsearch-api']).freeze

namespace :test do
  task bundle: 'bundle:install'

  desc 'Run all tests in all subprojects'
  task client: [:unit, :integration]

  desc 'Run unit tests in all subprojects'
  task :unit do
    UNIT_TESTED_PROJECTS.each do |project|
      puts '-' * 80
      sh "cd #{CURRENT_PATH.join(project)} && unset BUNDLE_GEMFILE && unset BUNDLE_PATH && unset BUNDLE_BIN && bundle exec rake test:unit"
      puts "\n"
    end
  end

  desc 'Run integration tests in all subprojects'
  task :integration do
    INTEGRATION_TESTED_PROJECTS.each do |project|
      puts '-' * 80
      sh "cd #{CURRENT_PATH.join(project)} && unset BUNDLE_GEMFILE && bundle exec rake test:integration"
      puts "\n"
    end
  end

  desc 'Run rest api tests'
  task rest_api: ['elasticsearch:wait_for_green'] do
    puts '-' * 80
    sh "cd #{CURRENT_PATH.join('elasticsearch-api')} && unset BUNDLE_GEMFILE && bundle exec rake test:rest_api[true]"
    puts "\n"
  end

  desc 'Run security (Platinum) rest api yaml tests'
  task security: 'elasticsearch:wait_for_green' do
    puts '-' * 80
    sh "cd #{CURRENT_PATH.join('elasticsearch-xpack')} && unset BUNDLE_GEMFILE && bundle exec rake test:rest_api"
    puts "\n"
  end

  desc 'Download test artifacts for running cluster'
  task :download_artifacts do
    require 'elasticsearch'
    begin
      es_version_info = admin_client.info['version']
      version_number = es_version_info['number']
      build_hash = es_version_info['build_hash']
    rescue Faraday::ConnectionFailed => e
      STDERR.puts "[!] Test cluster not running?"
      abort e
    end

    unless build_hash
      STDERR.puts "[!] Cannot determine checkout build hash -- server not running"
      exit(1)
    end

    puts 'Downloading artifacts file.'
    filename = CURRENT_PATH.join('tmp/artifacts.json')

    # Download with Ruby
    begin
      Dir.mkdir(CURRENT_PATH.join('tmp'), 0700) unless File.directory?(CURRENT_PATH.join('tmp'))
      require 'open-uri'
      File.open(filename, "w") do |downloaded_file|
        URI.open("https://artifacts-api.elastic.co/v1/versions/#{version_number}", "rb") do |artifact_file|
          downloaded_file.write(artifact_file.read)
        end
      end
      puts "Successfully downloaded #{filename}"
    rescue StandardError => e
      STDERR.puts "[!] Failed to download artifact to #{filename}"
      raise e
      exit 1
    end

    unless File.exists?(filename)
      STDERR.puts '[!] Couldn\'t download artifacts file'
      exit 1
    end

    artifacts = JSON.parse(File.read(filename))

    build_hash_artifact = artifacts['version']['builds'].select do |a|
      a.dig('projects', 'elasticsearch', 'commit_hash') == build_hash
    end.first
    # Dig into the elasticsearch packages, search for the rest-resources-zip package and catch the URL:
    zip_url = build_hash_artifact.dig('projects', 'elasticsearch', 'packages').select { |k,v| k =~ /rest-resources-zip/ }.map { | _, v| v['url'] }.first

    filename = zip_url.split('/').last
    puts 'Downloading zip file.'
    `curl -s #{zip_url} -o tmp/#{filename}`

    unless File.exists?("./tmp/#{filename}")
      STDERR.puts '[!] Couldn\'t download artifact'
      exit 1
    end

    puts "Unzipping file #{filename}"
    `unzip -o tmp/#{filename} -d tmp/`
    `rm tmp/#{filename}`
    puts 'Artifacts downloaded in ./tmp'
  end
end
