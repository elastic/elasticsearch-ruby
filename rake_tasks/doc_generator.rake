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

    entries = json_data.select { |d| d['lang'] == 'console' }
    entries.each_with_index do |entry, index|
      percentage = index * 100 / entries.length
      print "\r" + ("\e[A\e[K") if index > 0
      puts "Generating file #{index + 1} of #{entries.length} - #{percentage}% complete"
      generate_docs(entry)
    end
  end

  def json_data
    JSON.parse(File.read(SRC_FILE))
  end

  def generate_docs(entry)
    filename = "#{entry['digest']}.asciidoc"
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

      code = "response = client.#{api}(\n#{request_body}\n)\nputs response"
      client_query << format_code(code)
    end
    client_query.join("\n\n")
  end

  def self.format_code(code)
    # Print code to the file
    File.open('temp.rb', 'w') do |f|
      f.puts code
    end
    # Format code:
    system("rubocop --config #{__dir__}/docs_rubocop_config.yml -o /dev/null -a ./temp.rb")
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

  def write_file(code, file)
    File.open("#{TARGET_DIR}/#{file}", 'w') do |f|
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
  require 'elasticsearch'
  @formatter = -> (_, d, _, msg) { "#{d}: #{msg}" }

  def self.perform(code, filename)
    # Eval the example code, but remove printing out the response
    eval(code.gsub('puts response', ''))
  rescue Elastic::Transport::Transport::Error => e
    logger = Logger.new('log/docs-generation-elasticsearch.log')
    logger.formatter = @formatter
    logger.info("Located in #{filename}: #{e.message}\n")
  rescue ArgumentError => e
    logger = Logger.new('log/docs-generation-client.log')
    logger.formatter = @formatter
    logger.info("Located in #{filename}: #{e.message}\n")
  end

  def self.client
    @client ||= Elasticsearch::Client.new(trace: false, log: false)
  end
end
