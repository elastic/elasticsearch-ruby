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
  'elasticsearch-api'
].freeze

INTEGRATION_TESTED_PROJECTS = (UNIT_TESTED_PROJECTS - ['elasticsearch-api']).freeze

namespace :test do
  require 'open-uri'
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
    sh "cd #{CURRENT_PATH.join('elasticsearch-api')} && unset BUNDLE_GEMFILE && bundle exec rake test:rest_api"
    puts "\n"
  end

  desc 'Run security (Platinum) rest api yaml tests'
  task security: 'elasticsearch:wait_for_green' do
    puts '-' * 80
    sh "cd #{CURRENT_PATH.join('elasticsearch-api')} && unset BUNDLE_GEMFILE && TEST_SUITE=platinum bundle exec rake test:rest_api"
    puts "\n"
  end

  # Returns: version_number, build_hash
  def cluster_info
    require 'elasticsearch'
    version_info = admin_client.info['version']
    abort('[!] Cannot determine cluster version information -- Is the server running?') unless version_info

    version_info
  rescue Faraday::ConnectionFailed => e
    STDERR.puts "[!] Test cluster not running?"
    abort e
  end

  def package_url(filename, build_hash)
    begin
      artifacts = JSON.parse(File.read(filename))
    rescue StandardError => e
      STDERR.puts "[!] Couldn't read JSON file #{filename}"
      exit 1
    end

    build_hash_artifact = artifacts['version']['builds'].select do |build|
      build.dig('projects', 'elasticsearch', 'commit_hash') == build_hash
    end.first

    unless build_hash_artifact
      STDERR.puts "[!] Could not find artifact with build hash #{build_hash}, using latest instead"
      build_hash_artifact = artifacts['version']['builds'].first
    end

    # Dig into the elasticsearch packages, search for the rest-resources-zip package and return the URL:
    build_hash_artifact.dig('projects', 'elasticsearch', 'packages').select { |k,v| k =~ /rest-resources-zip/ }.map { | _, v| v['url'] }.first
  end

  def download_file!(url, filename)
    puts "Downloading #{filename} from #{url}"
    File.open(filename, "w") do |downloaded_file|
      URI.open(url, "rb") do |artifact_file|
        downloaded_file.write(artifact_file.read)
      end
    end
    puts "Successfully downloaded #{filename}"

    unless File.exists?(filename)
      STDERR.puts "[!] Couldn't download #{filename}"
      exit 1
    end
  rescue StandardError => e
    abort e
  end
end
