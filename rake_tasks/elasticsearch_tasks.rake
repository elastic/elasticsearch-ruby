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
      rescue Elastic::Transport::Transport::Errors::RequestTimeout => e
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

  def package_url(filename)
    begin
      artifacts = JSON.parse(File.read(filename))
    rescue StandardError => e
      STDERR.puts "[!] Couldn't read JSON file #{filename}"
      exit 1
    end

    build_hash_artifact = artifacts['version']['builds'].select do |build|
      build.dig('projects', 'elasticsearch', 'commit_hash') == @build_hash
    end.first

    unless build_hash_artifact
      STDERR.puts "[!] Could not find artifact with build hash #{@build_hash}, using latest instead"

      build_hash_artifact = artifacts['version']['builds'].first
      @build_hash = artifacts['version']['builds'].first['projects']['elasticsearch']['commit_hash']
    end

    # Dig into the elasticsearch packages, search for the rest-resources-zip package and return the URL:
    build_hash_artifact.dig('projects', 'elasticsearch', 'packages').select { |k, _| k =~ /rest-resources-zip/ }.map { |_, v| v['url'] }.first
  end

  def download_file!(url, filename)
    puts "Downloading #{filename} from #{url}"
    File.open(filename, "w") do |downloaded_file|
      URI.open(url, "rb") do |artifact_file|
        downloaded_file.write(artifact_file.read)
      end
    end
    puts "Successfully downloaded #{filename}"

    unless File.exist?(filename)
      warn "[!] Couldn't download #{filename}"
      exit 1
    end
  rescue StandardError => e
    abort e
  end

  desc 'Download artifacts (tests and REST spec) for currently running cluster'
  task :download_artifacts, :version do |_, args|
    json_filename = CURRENT_PATH.join('tmp/artifacts.json')

    unless (version_number = args[:version] || ENV['STACK_VERSION'])
      # Get version number and build hash of running cluster:
      version_number = cluster_info['number']
      @build_hash = cluster_info['build_hash']
      puts "Build hash: #{@build_hash}"
    end

    # Create ./tmp if it doesn't exist
    Dir.mkdir(CURRENT_PATH.join('tmp'), 0700) unless File.directory?(CURRENT_PATH.join('tmp'))

    # Download json file with package information for version:
    json_url = "https://artifacts-api.elastic.co/v1/versions/#{version_number}"
    download_file!(json_url, json_filename)

    # Get the package url from the json file given the build hash
    zip_url = package_url(json_filename)

    # Download the zip file
    filename = CURRENT_PATH.join("tmp/#{zip_url.split('/').last}")
    download_file!(zip_url, filename)

    spec = CURRENT_PATH.join('tmp/rest-api-spec')
    FileUtils.remove_dir(spec) if File.directory?(spec)

    puts "Unzipping file #{filename}"
    `unzip -o #{filename} -d tmp/`
    `rm #{filename}`
    puts "Artifacts downloaded in ./tmp, build hash #{@build_hash}"
    File.write(CURRENT_PATH.join('tmp/rest-api-spec/build_hash'), @build_hash)
  end

  desc 'Check Elasticsearch health'
  task :health do
    require 'elasticsearch'

    puts "ELASTICSEARCH_HOST: #{ENV['ELASTICSEARCH_HOST']}"

    client = Elasticsearch::Client.new(host: ELASTICSEARCH_HOST)
    puts client.cluster.health
  end
end
