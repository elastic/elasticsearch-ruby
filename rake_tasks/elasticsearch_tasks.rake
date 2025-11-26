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

namespace :es do
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

  desc 'Automatically update to latest version'
  task :autoupdate_version do
    require 'tempfile'

    branch = `git branch --show-current`.strip
    url = "https://snapshots.elastic.co/latest/#{branch}.json"
    file = Tempfile.new('version')
    download_file!(url, file)
    version = JSON.parse(file.read)['version']
    puts "Latest version is #{version}"
    Rake::Task['automation:bumpmatrix'].invoke(version)
  end

  def download_file!(url, filename)
    puts "Downloading #{filename} from #{url}"
    File.open(filename, 'w') do |downloaded_file|
      URI.open(url, 'rb') do |artifact_file|
        downloaded_file.write(artifact_file.read)
      end
    end
    puts "Successfully downloaded #{filename}"

    unless File.exist?(filename)
      warn "[!] Couldn't download #{filename}"
      exit 1
    end
  rescue OpenURI::HTTPError => e
    abort e.message
  rescue StandardError => e
    puts e.backtrace.join("\n\t")
    abort e.message
  end

  desc 'Download artifacts (tests and REST spec) a given version'
  task :download_artifacts, :version do |_, args|
    require 'net/http'

    json_filename = CURRENT_PATH.join('tmp/artifacts.json')
    version_number = args[:version] || ENV['STACK_VERSION'] || version_from_buildkite || version_from_running_cluster
    # Create ./tmp if it doesn't exist
    Dir.mkdir(CURRENT_PATH.join('tmp'), 0700) unless File.directory?(CURRENT_PATH.join('tmp'))

    # TODO: If required, bring back the functionality to download a specific build.
    # This was implemented in the previous version of the API, but research is needed to see how it
    # works in new API.
    #
    # Get the latest minor from version number, and get latest snapshot
    major_minor = version_number.split('.')[0..1].join('.')
    url = URI("https://artifacts-snapshot.elastic.co/elasticsearch/latest/#{major_minor}.json")
    manifest_url = JSON.parse(Net::HTTP.get(url))['manifest_url']
    download_file!(manifest_url, json_filename)

    # Parse the downloaded JSON
    begin
      artifacts = JSON.parse(File.read(json_filename))
    rescue StandardError => e
      warn "[!] Couldn't read JSON file #{json_filename}\n#{e.message}"
      exit 1
    end

    # Search the JSON for the rest-resources-zip file and get the URL
    packages = artifacts.dig('projects', 'elasticsearch', 'packages')
    rest_resources = packages.select { |k, v| k =~ /rest-resources/ }
    zip_url = rest_resources.map { |_, v| v['url'] }.first

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

  def version_from_buildkite
    require 'yaml'
    yaml = YAML.load_file(File.expand_path('../.buildkite/pipeline.yml', __dir__))
    yaml['steps'].first['env']['STACK_VERSION']
  end

  def version_from_running_cluster
    info = cluster_info
    @build_hash = info['build_hash'] if info['build_hash']
    info['number']
  end

  desc 'Check Elasticsearch health'
  task :health do
    require 'elasticsearch'

    puts "ELASTICSEARCH_HOST: #{ENV['ELASTICSEARCH_HOST']}"

    client = Elasticsearch::Client.new(hosts: [ENV['ELASTICSEARCH_HOST']])
    puts client.cluster.health
  end
end
