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

namespace :unified_release do
  desc 'Build gem releases and snapshots'
  task :assemble, [:version, :output_dir] do |_, args|
    if ENV['WORKFLOW'] == 'snapshot'
      @zip_filename = "elasticsearch-ruby-#{args[:version]}-SNAPSHOT"
      @version = "#{args[:version]}.#{Time.now.strftime('%Y%m%d%H%M%S')}-SNAPSHOT"
    else
      @version = args[:version]
      @zip_filename = "elasticsearch-ruby-#{@version}"
    end

    Rake::Task['unified_release:bump'].invoke(@version) unless @version == Elasticsearch::VERSION

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

  desc 'Generate API code'
  task :codegen do
    version = YAML.load_file(File.expand_path(__dir__ + '/../.buildkite/pipeline.yml'))['steps'].first['env']['STACK_VERSION']

    Rake::Task['elasticsearch:download_artifacts'].invoke(version)
    sh "cd #{CURRENT_PATH.join('elasticsearch-api/utils')} \
          && BUNDLE_GEMFILE=`pwd`/Gemfile \
          && bundle exec thor code:generate"
  end

  desc <<-DESC
  Update Rubygems versions in version.rb and *.gemspec files

  Example:

      $ rake unified_release:bump[42.0.0]
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

      $ rake unified_release:bump_matrix[42.0.0]
  DESC
  task :bumpmatrix, :version do |_, args|
    abort('[!] Required argument [version] missing') unless (version = args[:version])

    files = [
      '.github/workflows/main.yml',
      '.buildkite/pipeline.yml'
    ]
    regexp = Regexp.new(/([0-9]{1,2}\.[0-9]{1,2}\.[0-9]{1,2}?+(-SNAPSHOT)?)/)
    files.each do |file|
      content = File.read(file)
      match = content.match(regexp)
      old_version = match[1]
      content.gsub!(old_version, args[:version])
      puts "[#{old_version}] -> [#{version}] in #{file.gsub('./', '')}"
      File.open(file, 'w') { |f| f.puts content }
    end
  end
end
