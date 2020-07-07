require 'json'
require 'fileutils'

namespace :docs do
  SRC_FILE          = "#{__dir__}/docs/parsed_alternative_report.json".freeze
  EXAMPLES_TO_PARSE = JSON.parse(File.read("#{__dir__}/docs/examples_to_parse.json")).freeze
  TARGET_DIR        = "#{__dir__}/../docs/examples/guide".freeze

  desc 'Generate doc examples'
  task :generate do
    # Remove existing documents to avoid having outdated files
    FileUtils.remove_dir(TARGET_DIR)
    Dir.mkdir(TARGET_DIR)

    # Only select the files in the EXAMPLES_TO_PARSE array and that are not
    # console result examples
    entries = json_data.select do |d|
      EXAMPLES_TO_PARSE.include? d['source_location']['file']
    end.select { |d| d['lang'] == 'console' }

    entries.each do |entry|
      generate_docs(entry)
    end
  end

  def json_data
    JSON.parse(File.read(SRC_FILE))
  end

  def generate_docs(entry)
    file_name = "#{entry['digest']}.asciidoc"
    api = entry['parsed_source'].first['api']
    code = build_client_query(api, entry)
    write_file(code, file_name)
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
      request_body = request_body.compact.join(",\n")
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
    system("rubocop --config #{__dir__}/docs_rubocop_config.yml --format autogenconf -a ./temp.rb")
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
