# frozen_string_literal: true

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
require 'fileutils'
require_relative '../elasticsearch/lib/elasticsearch/version'

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

  desc 'Publish gems to Rubygems'
  task :publish do
    setup_credentials

    RELEASE_TOGETHER.each do |gem|
      puts '-' * 80
      puts "Releasing #{gem} v#{Elasticsearch::VERSION}"
      sh "cd #{CURRENT_PATH.join(gem)} && bundle exec rake release"
    end
  end

  def setup_credentials
    raise ArgumentError, 'You need to set the env value for GITHUB_TOKEN' unless ENV['GITHUB_TOKEN']
    raise ArgumentError, 'You need to set the env value for RUBYGEMS_API_KEY' unless ENV['RUBYGEMS_API_KEY']

    sh 'git config --global user.email ${GIT_EMAIL} && ' \
       'git config --global user.name ${GIT_NAME}'

    file_name = File.expand_path('~/.gem/credentials')
    text = <<~CREDENTIALS
      ---
      :github: Bearer #{ENV['GITHUB_TOKEN']}
      :rubygems_api_key: #{ENV['RUBYGEMS_API_KEY']}
    CREDENTIALS
    File.open(file_name, 'w') do |file|
      file.write(text)
    end

    FileUtils.chmod 0o600, file_name
  end
end
