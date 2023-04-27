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

require 'json'
require 'fileutils'
require 'logger'

namespace :docs do
  SRC_FILE          = "#{__dir__}/docs/parsed_alternative_report.json".freeze
  EXAMPLES_TO_PARSE = JSON.parse(File.read("#{__dir__}/docs/examples_to_parse.json")).freeze
  TARGET_DIR        = "#{__dir__}/../docs/examples/guide".freeze

  desc 'Generate doc examples'
  task :generate do
    # Remove existing documents to avoid having outdated files
    FileUtils.remove_dir(TARGET_DIR)
    Dir.mkdir(TARGET_DIR)
    Dir['log/*.log'].each { |f| File.delete(f) }

    entries = json_data.select { |d| d['lang'] == 'console' }
    start_time = Time.now.to_i
    entries.each_with_index do |entry, index|
      percentage = index * 100 / entries.length
      hourglass = index.even? ? '⌛ ' : '⏳ '
      # print "\r" + ("\e[A\e[K" * 2) if index > 0
      puts "\e[H\e[2J"
      puts "📝 Generating file #{index + 1} of #{entries.length} - #{percentage}% complete"
      puts hourglass + '▩' * (percentage / 2) + '⬚' * (50 - percentage / 2) + ' ' + hourglass
      generate_docs(entry)
    end
    puts "Finished generating #{entries.length} files in #{Time.now.to_i - start_time} seconds"
  end

  desc 'Update report'
  task :update do
    require 'elastic-transport'
    github_token = File.read(File.expand_path("~/.elastic/github.token"))
    transport_options = {
      headers: {
        Accept: 'application/vnd.github.v3.raw',
        Authorization: "token #{github_token}"
      }
    }
    client = Elastic::Transport::Client.new(
      host: 'https://api.github.com/',
      transport_options:transport_options
    )
    path = '/repos/elastic/clients-flight-recorder/contents/recordings/docs/parsed-alternative-report.json'
    params = {}
    response = client.perform_request('GET', path, params)
    File.write(File.expand_path('./docs/parsed_alternative_report.json', __dir__), response.body)
  end

  def json_data
    JSON.parse(File.read(SRC_FILE))
  end

  def generate_docs(entry)
    require 'elasticsearch'

    filename = File.expand_path("#{TARGET_DIR}/#{entry['digest']}.asciidoc")
    unless entry['parsed_source'].empty?
      api = entry['parsed_source'].first['api']
      code = build_client_query(api, entry)
      TestDocs::perform(code, filename)
      write_file(code, filename)
    end
  end

  def self.build_client_query(api, entry)
    client_query = []
    entry['parsed_source'].each do |entry|
      request_body = []
      query = entry&.[]('query')
      params = entry&.[]('params')
      params = params&.merge(query) || query if query
      request_body << show_parameters(params) if params
      body = entry&.[]('body')
      request_body << show_body(body) if body
      request_body = request_body.compact.join(",\n").gsub('null', 'nil')
      code = if api.include? '_internal'
               "response = client.perform_request('#{entry['method']}', '#{api}', #{request_body})"
             else
               "response = client.#{api}(\n#{request_body}\n)\nputs response"
             end
      client_query << format_code(code)
    end
    client_query.join("\n\n")
  end

  def self.format_code(code)
    # Print code to the file
    File.open('temp.rb', 'w') do |f|
      f.puts code
    end
    # Format code with Rubocop
    require 'rubocop'
    options = "--config #{__dir__}/docs_rubocop_config.yml -o /dev/null -a ./temp.rb".split
    cli = RuboCop::CLI.new
    cli.run(options)

    # Read it back
    template = File.read('./temp.rb')
    File.delete('./temp.rb')

    # TODO: Manually remove final blank line since Rubocop is ignoring the config directive
    template.gsub(/\s+$/, '')
  end

  def self.show_parameters(params)
    param_string = []
    params.each do |k, v|
      value = (is_number?(v) || is_boolean?(v)) ? v : "'#{v}'"
      param_string << "#{k.gsub('\"','')}: #{value}"
    end
    param_string.join(",\n\s\s")
  end

  def self.show_body(body)
    'body: ' +
      JSON.pretty_generate(body)
        .gsub(/\"([a-z_]+)\":/,'\\1: ') # Use Ruby 2 hash syntax
        .gsub('aggs', 'aggregations')   # Replace 'aggs' with 'aggregations' for consistency
  end

  def self.is_number?(value)
    Float(value) || Integer(value) rescue false
  end

  def self.is_boolean?(value)
    (['false', 'true'].include? value) ||
                               value.is_a?(TrueClass) ||
                               value.is_a?(FalseClass)
  end

  def write_file(code, filename)
    File.open(filename, 'w') do |f|
      f.puts <<~SRC
        [source, ruby]
        ----
        #{code}
        ----
      SRC
    end
  end
end

#
# Test module to run the generated code
#
module TestDocs
  @formatter = -> (_, d, _, msg) { "[#{d}] : #{msg}" }

  def self.perform(code, filename)
    # Eval the example code, but remove printing out the response
    response = eval(code.gsub('puts response', ''))
    log_successful_code(filename) if response.status == 200
  rescue Elastic::Transport::Transport::Errors::NotFound => e
    log_successful_code(filename)
  rescue Elastic::Transport::Transport::Error => e
    logger = Logger.new('log/docs-generation-elasticsearch.log')
    logger.formatter = @formatter
    logger.info("Located in #{filename}: #{e.message}\n")
  rescue ArgumentError, NoMethodError, TypeError => e
    logger = Logger.new('log/docs-generation-client.log')
    logger.formatter = @formatter
    logger.info("Located in #{filename}: #{e.message}\n")
  end

  def self.client
    @client ||= Elasticsearch::Client.new(trace: false, log: false)
  end

  def self.log_successful_code(filename)
    logger = Logger.new('log/200-ok.log')
    logger.formatter = -> (_, _, _, msg) { "#{msg} " }
    logger.info(filename)
  end
end
