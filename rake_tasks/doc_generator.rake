require 'json'

namespace :docs do
  SRC_FILE          = "#{__dir__}/docs/parsed_alternative_report.json".freeze
  EXAMPLES_TO_PARSE = JSON.parse(File.read("#{__dir__}/docs/examples_to_parse.json")).freeze
  TARGET_DIR        = "#{__dir__}/../docs/examples/guide".freeze

  desc 'Generate doc examples'
  task :generate do
    # Remove existing documents to avoid having outdated files
    Dir.foreach(TARGET_DIR) do |f|
      File.delete(File.join(TARGET_DIR), f) if !f =~ /^\.{1,2}$/
    end
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
    request_body = []
    query = entry['parsed_source'].first&.[]('query')
    params = entry['parsed_source'].first&.[]('params')
    params = params&.merge(query) || query if query
    request_body << show_parameters(params) if params
    body = entry['parsed_source'].first&.[]('body')
    request_body << show_body(body) if body
    request_body = request_body.compact.join(",\n")

    template = <<~SRC
      client.#{api}(
        #{request_body}
      )
    SRC

    # Remove trailing whitespace
    template.gsub(/\s+$/, '')
  end

  def self.show_parameters(params)
    param_string = []
    params.each do |k, v|
      value = is_number?(v) ? v : "'#{v}'"
      param_string << "#{k.gsub('\"','')}: #{value}"
    end
    param_string.join(",\n\s\s")
  end

  def self.show_body(body)
    '  body:' +
      JSON.pretty_generate(body)
        .gsub(/\"([a-z_]+)\":/,'\\1: ') # Use Ruby 2 hash syntax
        .gsub('aggs', 'aggregations')   # Replace 'aggs' with 'aggregations' for consistency
        .gsub(/(.*)/, '  \1')           # Add indentation
        .gsub(/\s+({|\[)/,"\s\\1")      # Clean whitespace before { and ['s
  end

  def self.is_number?(value)
    Float(value) || Integer(value) rescue false
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
