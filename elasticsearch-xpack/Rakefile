require 'bundler/gem_tasks'

require 'rake/testtask'

task :default do
  exec "rake --tasks"
end

Rake::TestTask.new('test:unit') do |test|
  test.libs << 'test'
  test.test_files = FileList['test/unit/**/*_test.rb']
  test.verbose = false
  test.warning = false
end

namespace :test do
  desc "Run integration tests"
  task :integration do
    require 'ansi'

    suites = %w[
      plugin/src/test/resources/rest-api-spec/test/
    ]

    # TEMPORARY
    disabled_suites = %w[
    ]

    suites = (suites + disabled_suites).select! { |d| d =~ Regexp.new(ENV['SUITE'].gsub(/,/, '|')) } if ENV['SUITE']

    executed_suites = []

    at_exit do
      errors = executed_suites.any? { |d| d.values.first == 1 }
      color  = errors ? :red : :green

      if errors
        puts "----- ".ansi(color) + "ERROR".ansi(color).ansi(:bold) + ('-'*(80-12)).ansi(color)
      else
        puts "----- ".ansi(color) + "SUCCESS".ansi(color).ansi(:bold) + ('-'*(80-13)).ansi(color)
      end

      executed_suites.each do |d|
        name = d.keys.first.gsub(%r{x-plugins/elasticsearch/x-pack/([^/]+)/.*}, '\1')
        status = d.values.first == 0 ? 'OK'.ansi(:green) : 'KO'.ansi(:red)
        puts "#{status} #{name.ansi(:bold)}"
      end

      puts ('-'*80).ansi(color)

      exit( errors ? 1 : 0 )
    end

    suites.each do |suite|
      begin
        sh <<-COMMAND
          TEST_REST_API_SPEC=../x-pack-elasticsearch/#{suite} bundle exec ruby -I lib:test test/integration/yaml_test_runner.rb
        COMMAND
        executed_suites << { suite => 0 }
      rescue RuntimeError
        executed_suites << { suite => 1 }
      end

      puts '', '-'*80, ''
    end
  end

  desc "Run Elasticsearch with X-Pack installed (Docker)"
    task :server do
      sh <<-COMMAND.gsub(/^\s*/, '').gsub(/\s{1,}/, ' ')
        docker run \
          --name elasticsearch-xpack \
          --env ELASTIC_PASSWORD=changeme \
          --env cluster.name=elasticsearch-xpack-test \
          --publish 9260:9200 \
          --memory 4g \
          --rm \
          docker.elastic.co/elasticsearch/elasticsearch-platinum:6.1.1
      COMMAND
    end
end
