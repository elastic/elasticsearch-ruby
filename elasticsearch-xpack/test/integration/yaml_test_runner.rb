RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
JRUBY    = defined?(JRUBY_VERSION)

require 'pathname'
require 'logger'
require 'yaml'
require 'active_support/inflector'
require 'ansi'

require 'elasticsearch'
require 'elasticsearch/extensions/test/cluster'
require 'elasticsearch/extensions/test/startup_shutdown'
require 'elasticsearch/extensions/test/profiling' unless JRUBY

require 'test_helper'

# Skip features
skip_features = 'stash_in_path,requires_replica,warnings'
SKIP_FEATURES = ENV.fetch('TEST_SKIP_FEATURES', skip_features)

# Skip files where a pattern matches
default_skip_patterns = [
  '/xpack/10_basic.yml',      # Test fails, doesn't counts with more plugins installed, like `ingest-geoip`
  '/xpack/15_basic',          # Test inserts invalid license, making all subsequent tests fail
  '/license/20_put_license',  # Test inserts invalid license, making all subsequent tests fail
  '/token/',                  # Tokens require full SSL setup (TODO)
  '/ssl/10_basic',            # (?) Test relies on some external setup
  '/ml/jobs_crud.yml',        # (?) Test expects settings?
  '/ml/ml_info.yml'           # Test doesn't reset itself in teardown
].join('|')

SKIP_PATTERNS = Regexp.new( [default_skip_patterns, ENV['TEST_SKIP_PATTERNS'] ].compact.join('|') )

class String
  # Reset the `ansi` method on CI
  def ansi(*args)
    self
  end
end if ENV['CI']

module CapturedLogger
  def self.included base
    base.class_eval do
      %w[ info error warn fatal debug ].each do |m|
        alias_method "#{m}_without_capture", m

        define_method m do |*args|
          @logdev.__send__ :puts, *(args.join("\n") + "\n")
          self.__send__ "#{m}_without_capture", *args
        end
      end
    end
  end
end

Logger.__send__ :include, CapturedLogger if ENV['CI']

$logger = Logger.new($stderr)
$logger.progname = 'elasticsearch'
$logger.formatter = proc do |severity, datetime, progname, msg|
  color = case severity
    when /INFO/ then :green
    when /ERROR|WARN|FATAL/ then :red
    when /DEBUG/ then :cyan
    else :white
  end
  "#{severity[0]} ".ansi(color, :faint) + msg.ansi(:white, :faint) + "\n"
end

$tracer = Logger.new($stdout)
$tracer.progname = 'elasticsearch.tracer'
$tracer.formatter = proc { |severity, datetime, progname, msg| "#{msg}\n" }

if ENV['ELASTIC_PASSWORD']
  password = ENV['ELASTIC_PASSWORD']
else
  password = begin
    puts "The ELASTIC_PASSWORD environment variable is not set, getting password by running `bin/elasticsearch-setup-passwords`...".ansi(:faint)
    out = `docker exec -it elasticsearch-xpack bin/elasticsearch-setup-passwords auto --batch`
    matches = out.match(/PASSWORD elastic = (\S+)/)
    if matches && matches.captures.first
      matches.captures.first
    else
      puts "\nCannot get password from Docker:".ansi(:bold, :red)
      puts out.to_s.ansi(:faint)
      exit(1)
    end
  end
  puts "Password succesfully generated, export it in your shell for subsequent runs:".ansi(:faint),
        "export ELASTIC_PASSWORD=#{password}"
end

$url = ENV.fetch('TEST_CLUSTER_URL', "http://elastic:#{password}@localhost:#{ENV['TEST_CLUSTER_PORT'] || 9260}")

puts '-'*80, "Connecting to <#{$url}>".ansi(:bold, :faint)

$client        ||= Elasticsearch::Client.new url: $url
$helper_client ||= Elasticsearch::Client.new url: $url

es_version_info = $helper_client.info['version']
xpack_info      = $helper_client.xpack.info
plugins         = $helper_client.cat.plugins(format: 'json')
$es_version = es_version_info['number']

puts '-'*80,
     "Elasticsearch #{$es_version.ansi(:bold)} [#{es_version_info['build_hash'].to_s[0...7]}]",
     "Plugins: " + plugins.map { |d| "#{d['component'].ansi(:bold)}:#{d['version']}"}.join(', '),
     "X-Pack #{xpack_info['license']['type']} license is #{xpack_info['license']['status'].ansi(:bold)} and expires at #{Time.at(xpack_info['license']['expiry_date_in_millis']/1000)}",
     '-'*80

$client.transport.logger = $logger unless ENV['QUIET'] || ENV['CI']
$original_client = $client.clone

module Minitest
  module Reporters
    class SpecReporter
      def record_print_status(test)
        test_name = test.name.gsub(/^test_: (.+) should (.+)/, '[\1] \2')
        print pad_test(test_name)
        print_colored_status(test)
        print(" (%.2fs)" % test.time) unless test.time.nil?
        puts
      end
    end
  end
end

module Elasticsearch
  module YamlTestSuite
    $last_response = ''
    $results = {}
    $stash   = {}

    module Utils
      def titleize(word)
        word.to_s.gsub(/[^\w]+/, ' ').gsub(/\b('?[a-z])/) { $1.capitalize }.tr('_', ' ')
      end

      def symbolize_keys(object)
        if object.is_a? Hash
          object.reduce({}) { |memo,(k,v)| memo[k.to_sym] = symbolize_keys(v); memo }
        else
          object
        end
      end

      extend self
    end

    module Runner
      def perform_api_call(test, api, arguments=nil)
        namespace = api.split('.')

        replacer = lambda do |value|
          case value
            when Array
              value.map { |v| replacer.call(v) }
            when Hash
              Hash[ value.map { |v| replacer.call(v) } ]
            else
              fetch_or_return value
          end
        end

        timefixer = lambda do |value|
          if value.is_a?(Time)
            value.iso8601
          else
            value
          end
        end

        arguments = Hash[
          arguments.map do |key, value|
            replacement = replacer.call(value)
            replacement = timefixer.call(replacement)
            [key, replacement]
          end
        ]

        $stderr.puts "[#{api}] ARGUMENTS: #{arguments.inspect}" if ENV['DEBUG']

        $last_response = namespace.reduce($client) do |memo, current|
          unless current == namespace.last
            memo = memo.send(current)
          else
            arguments ? memo = memo.send(current, arguments) : memo = memo.send(current)
          end
          memo
        end

        $results[test.hash] = $last_response
      end

      def evaluate(test, property, response=nil)
        response ||= $results[test.hash]
        property.gsub(/\\\./, '_____').split('.').reduce(response) do |memo, attr|
          if memo
            if attr
              attr = attr.gsub(/_____/, '.')
              attr = $stash[attr] if attr.start_with? '$'
            end
            case
              when memo.is_a?(Hash) && attr
                memo = memo[attr]
              when memo.is_a?(Array) && attr && attr =~ /^\d+$/
                memo = memo[attr.to_i]
              else
                memo = memo
            end
          end
          memo
        end
      end

      def in_context(name, &block)
        klass = Class.new(YamlTestCase)
        Object::const_set "%sTest" % name.split(/\s/).reject { |d| d.match(/^\d+/) }.map { |d| d.capitalize }.join('').gsub(/[^\w]+/, ''), klass
        klass.context name, &block
      end

      def fetch_or_return(var)
        if var.is_a?(String) && var =~ /^\$(.+)/
          $stash[var]
        else
          var
        end
      end

      def set(var, val)
        $stash["$#{var}"] = val
      end

      def skip?(actions)
        skip = actions.select { |a| a['skip'] }.first

        # Skip version
        if skip && skip['skip']['version']
          $stderr.puts "SKIP: #{skip.inspect}" if ENV['DEBUG']
          return skip['skip']['reason'] ? skip['skip']['reason'] : true if skip['skip']['version'] == 'all'

          min, max = skip['skip']['version'].split('-').map(&:strip)

          min_normalized = sprintf "%03d-%03d-%03d",
                           *min.split('.')
                               .map(&:to_i)
                               .fill(0, min.split('.').length, 3-min.split('.').length)

          max_normalized = sprintf "%03d-%03d-%03d",
                           *max.split('.')
                               .map(&:to_i)
                               .map(&:to_i)
                               .fill(0, max.split('.').length, 3-max.split('.').length)

          es_normalized  = sprintf "%03d-%03d-%03d", *$es_version.split('.').map(&:to_i)

          if ( min.empty? || min_normalized <= es_normalized ) && ( max.empty? || max_normalized >= es_normalized )
            return skip['skip']['reason'] ? skip['skip']['reason'] : true
          end

        # Skip features
        elsif skip && skip['skip']['features']
          skip_features = skip['skip']['features'].respond_to?(:split) ? skip['skip']['features'].split(',') : skip['skip']['features']
          if ( skip_features & SKIP_FEATURES.split(',') ).size > 0
            return skip['skip']['features']
          end
        end

        return false
      end

      extend self
    end

    class YamlTestCase < Minitest::Test; end
  end
end

include Elasticsearch::YamlTestSuite

rest_api_test_source = '../../../../tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test'
PATH = Pathname(ENV.fetch('TEST_REST_API_SPEC', File.expand_path(rest_api_test_source, __FILE__)))
raise Errno::ENOENT, "#{PATH}" unless PATH.exist?

suites  = Dir.glob(PATH.join('*')).map { |d| Pathname(d) }
suites  = suites.select { |s| s.to_s =~ Regexp.new(ENV['FILTER']) } if ENV['FILTER']

$stderr.puts "TEST SUITES: " + suites.map { |d| d.basename }.join(', ') if ENV['DEBUG']

suites.each do |suite|
  name = Elasticsearch::YamlTestSuite::Utils.titleize(suite.basename)

  Elasticsearch::YamlTestSuite::Runner.in_context name do
    # --- Register context setup -------------------------------------------
    #
    setup do
      # Prevent deleting the `.security*` index
      indices = $helper_client.indices.get(index: '_all').keys.reject { |i| i.start_with?('.security') }
      $helper_client.indices.delete index: indices, ignore: 404 unless indices.empty?
      $results = {}
      $stash   = {}

      # Cleanup for roles
      $helper_client.xpack.security.get_role.each do |role, _|
        begin
          $helper_client.xpack.security.delete_role name: role
        rescue
        end
      end

      # Cleanup for privileges
      $helper_client.xpack.security.get_privileges.each do |privilege, _|
        begin
          $helper_client.xpack.security.delete_privileges name: privilege
        rescue
        end
      end

      # Cleanup for users
      $helper_client.xpack.security.get_user.each do |user, _|
        begin
          $helper_client.xpack.security.delete_user username: user
        rescue
        end
      end

      # Setup machine learning user
      $helper_client.xpack.security.put_user username: 'x_pack_rest_user',  body: { password: 'x-pack-test-password', roles: ['superuser'] }

      # Cleanup for machine learning
      $helper_client.xpack.ml.stop_datafeed datafeed_id: '_all', force: true
      $helper_client.xpack.ml.get_datafeeds['datafeeds'].each do |d|
        $helper_client.xpack.ml.delete_datafeed datafeed_id: d['datafeed_id']
      end

      $helper_client.xpack.ml.close_job job_id: '_all', force: true
      $helper_client.xpack.ml.get_jobs['jobs'].each do |d|
        $helper_client.xpack.ml.delete_job job_id: d['job_id']
      end

      # $helper_client.cat.tasks(format: 'json')
      tasks = $helper_client.tasks.get['nodes'].values.first['tasks'].values.select { |d| d['cancellable'] }.map { |d| "#{d['node']}:#{d['id']}" }
      tasks.each { |t| $helper_client.tasks.cancel task_id: t }

      $helper_client.indices.delete index: '.ml-*', ignore: 404
    end

    # --- Register context teardown ----------------------------------------
    #
    teardown do
      $helper_client.xpack.ml.stop_datafeed datafeed_id: '_all', force: true
      $helper_client.xpack.ml.get_datafeeds['datafeeds'].each do |d|
        $helper_client.xpack.ml.delete_datafeed datafeed_id: d['datafeed_id']
      end

      $helper_client.xpack.ml.close_job job_id: '_all', force: true
      $helper_client.xpack.ml.get_jobs['jobs'].each do |d|
        $helper_client.xpack.ml.delete_job job_id: d['job_id']
      end

      $helper_client.indices.delete index: '_all', ignore: 404 if ENV['CLEANUP']
    end

    # --- Parse tests ------------------------------------------------------
    #
    Dir[suite.join('*.{yml,yaml}')].each do |file|

      if file =~ SKIP_PATTERNS
        $stderr.puts "#{'SKIP FILE'.ansi(:yellow)} #{file.gsub(PATH.to_s, '')}"
        next
      end

      tests = YAML.load_stream File.new(file)

      # Extract setup and teardown actions
      setup_actions    = tests.select { |t| t['setup'] }.first['setup'] rescue []
      teardown_actions = tests.select { |t| t['teardown'] }.first['teardown'] rescue []

      # Skip all the tests when `skip` is part of the `setup` part
      if features = Runner.skip?(setup_actions)
        $stdout.puts "#{'SKIP TEST'.ansi(:yellow)} [#{name}] #{file.gsub(PATH.to_s, '').ansi(:bold)} (Feature not implemented: #{features})"
        next
      end

      # Remove setup/teardown actions from tests
      tests = tests.reject { |t| t['setup'] || t['teardown'] }

      # Add setup/teardown actions to each individual test
      tests.each { |t| t[t.keys.first] << { 'setup'    => setup_actions } }
      tests.each { |t| t[t.keys.first] << { 'teardown' => teardown_actions } }

      tests.each do |test|
        context '' do
          test_name = test.keys.first.to_s.gsub(/test/i, '').strip.capitalize.ansi(:bold) +
                      " | #{file.gsub(PATH.to_s, '')}"
          actions   = test.values.first

          if reason = Runner.skip?(actions)
            $stdout.puts "#{'SKIP TEST'.ansi(:yellow)} [#{name}] #{test_name} (Reason: #{reason})"
            next
          end

          # --- Register test setup -------------------------------------------
          setup do
            actions.find { |a| a['setup'] }['setup'].each do |action|
              if action['do']
                if headers = action['do'] && action['do'].delete('headers')
                  puts "HEADERS: " + headers.inspect if ENV['DEBUG']
                  $client = Elasticsearch::Client.new url: $url, transport_options: { headers: headers }
                  $client.transport.logger = $logger unless ENV['QUIET'] || ENV['CI']
                else
                  $client = $original_client
                end

                api, arguments = action['do'].to_a.first
                arguments      = Utils.symbolize_keys(arguments)
                Runner.perform_api_call((test.to_s + '___setup'), api, arguments)
              end

              if action['set']
                stash = action['set']
                property, variable = stash.to_a.first
                result  = Runner.evaluate(test, property, $last_response)
                $stderr.puts "STASH: '$#{variable}' => #{result.inspect}" if ENV['DEBUG']
                Runner.set variable, result
              end
            end
          end

          # --- Register test teardown -------------------------------------------
          teardown do
            $client = $helper_client
            actions.select { |a| a['teardown'] }.first['teardown'].each do |action|
              if action['do']
                api, arguments = action['do'].to_a.first
                arguments      = Utils.symbolize_keys(arguments)
                Runner.perform_api_call((test.to_s + '___teardown'), api, arguments)
              end
              if action['set']
                stash = action['set']
                property, variable = stash.to_a.first
                result  = Runner.evaluate(test, property, $last_response)
                $stderr.puts "STASH: '$#{variable}' => #{result.inspect}" if ENV['DEBUG']
                Runner.set variable, result
              end
            end unless teardown_actions.empty?
          end

          # --- Register test method ------------------------------------------
          should test_name do
            actions.each do |action|
              $stderr.puts "ACTION: #{action.inspect}" if ENV['DEBUG']

              if headers = action['do'] && action['do'].delete('headers')
                puts "HEADERS: " + headers.inspect if ENV['DEBUG']
                $client = Elasticsearch::Client.new url: $url, transport_options: { headers: headers }
                $client.transport.logger = $logger unless ENV['QUIET'] || ENV['CI']
              else
                $client = $original_client
              end

              case

                # --- Perform action ------------------------------------------
                #
                when action['do']
                  catch_exception = action['do'].delete('catch') if action['do']
                  api, arguments = action['do'].to_a.first
                  arguments      = Utils.symbolize_keys(arguments)

                  begin
                    $results[test.hash] = Runner.perform_api_call(test, api, arguments)
                  rescue Exception => e
                    begin
                      $results[test.hash] = MultiJson.load(e.message.match(/{.+}/, 1).to_s)
                    rescue MultiJson::ParseError
                      $stderr.puts "RESPONSE: Cannot parse JSON from error message: '#{e.message}'" if ENV['DEBUG']
                    end

                    if catch_exception
                      $stderr.puts "CATCH: '#{catch_exception}': #{e.inspect}" if ENV['DEBUG']
                      case e
                        when 'missing'
                          assert_match /\[404\]/, e.message
                        when 'conflict'
                          assert_match /\[409\]/, e.message
                        when 'request'
                          assert_match /\[500\]/, e.message
                        when 'param'
                          raise ArgumentError, "NOT IMPLEMENTED"
                        when /\/.+\//
                          assert_match Regexp.new(catch_exception.tr('/', '')), e.message
                      end
                    else
                      raise e
                    end
                  end

                # --- Evaluate predicates -------------------------------------
                #
                when property = action['is_true']
                  result = Runner.evaluate(test, property)
                  $stderr.puts "CHECK: Expected '#{property}' to be true, is: #{result.inspect}" if ENV['DEBUG']
                  assert(result, "Property '#{property}' should be true, is: #{result.inspect}")

                when property = action['is_false']
                  result = Runner.evaluate(test, property)
                  $stderr.puts "CHECK: Expected '#{property}' to be nil, false, 0 or empty string, is: #{result.inspect}" if ENV['DEBUG']
                  assert "Property '#{property}' should be nil, false, 0 or empty string, but is: #{result.inspect}" do
                    result.nil? || result == false || result == 0 || result == ''
                  end

                when a = action['match']
                  property, value = a.to_a.first

                  if value.is_a?(String) && value =~ %r{\s*^/\s*.*\s*/$\s*}mx # Begins and ends with /
                    pattern = Regexp.new(value.strip[1..-2], Regexp::EXTENDED|Regexp::MULTILINE)
                  else
                    value  = Runner.fetch_or_return(value)
                  end

                  if property == '$body'
                    result = $results[test.hash]
                  else
                    result = Runner.evaluate(test, property)
                  end

                  if pattern
                    $stderr.puts "CHECK: Expected '#{property}' to match #{pattern}, is: #{result.inspect}" if ENV['DEBUG']
                    assert_match(pattern, result)
                  else
                    value = value.reduce({}) { |memo, (k,v)| memo[k] =  Runner.fetch_or_return(v); memo  } if value.is_a? Hash
                    $stderr.puts "CHECK: Expected '#{property}' to be '#{value}', is: #{result.inspect}" if ENV['DEBUG']

                    assert_equal(value, result)
                  end

                when a = action['length']
                  property, value = a.to_a.first

                  result = Runner.evaluate(test, property)
                  length = result.size
                  $stderr.puts "CHECK: Expected '#{property}' to be #{value}, is: #{length.inspect}" if ENV['DEBUG']
                  assert_equal(value, length)

                when a = action['lt'] || action['gt'] || action['lte'] || action['gte']
                  property, value = a.to_a.first
                  operator = case
                    when action['lt']
                      '<'
                    when action['gt']
                      '>'
                    when action['lte']
                      '<='
                    when action['gte']
                      '>='
                  end

                  result  = Runner.evaluate(test, property)
                  message = "Expected '#{property}' to be #{operator} #{value}, is: #{result.inspect}"

                  $stderr.puts "CHECK: #{message}" if ENV['DEBUG']
                  assert_operator result, operator.to_sym, value.to_i

                when stash = action['set']
                  property, variable = stash.to_a.first
                  result  = Runner.evaluate(test, property)
                  $stderr.puts "STASH: '$#{variable}' => #{result.inspect}" if ENV['DEBUG']
                  Runner.set variable, result
              end
            end
          end
        end
      end
    end

  end

end
