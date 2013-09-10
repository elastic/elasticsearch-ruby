require 'pathname'
require 'active_support/inflector'
require 'yaml'
require 'pry'

require 'elasticsearch'
require 'elasticsearch/client/extensions/test_cluster'

# Launch test cluster
#
Elasticsearch::TestCluster.start if ENV['SERVER']

# Register `at_exit` handler for server shutdown.
# MUST be called before requiring `test/unit`.
#
at_exit { Elasticsearch::TestCluster.stop if ENV['SERVER'] }

require 'logger'
require 'ansi'

logger = Logger.new(STDERR)
logger.formatter = proc do |severity, datetime, progname, msg|
  color = case severity
    when /INFO/ then :green
    when /ERROR|WARN|FATAL/ then :red
    when /DEBUG/ then :cyan
    else :white
  end
  ANSI.ansi(severity[0] + ' ', color, :faint) + ANSI.ansi(msg, :white, :faint) + "\n"
end

$client = Elasticsearch::Client.new host: 'localhost:9250', logger: (ENV['QUIET'] ? nil : logger)
$es_version = $client.info['version']['number']

puts '-'*80, "Elasticsearch #{ANSI.ansi($es_version, :bold)}", '-'*80

require 'test_helper'
require 'test/unit'
require 'shoulda/context'

# Monkeypatch shoulda to remove "should" from test name
#
module Shoulda
  module Context
    class Context
      def create_test_from_should_hash(should)
        test_name = ["test:", full_name, "--", "#{should[:name]}. "].flatten.join(' ').to_sym

        if test_methods[test_unit_class][test_name.to_s] then
          raise DuplicateTestError, "'#{test_name}' is defined more than once."
        end

        test_methods[test_unit_class][test_name.to_s] = true

        context = self
        test_unit_class.send(:define_method, test_name) do
          @shoulda_context = context
          begin
            context.run_parent_setup_blocks(self)
            should[:before].bind(self).call if should[:before]
            context.run_current_setup_blocks(self)
            should[:block].bind(self).call
          ensure
            context.run_all_teardown_blocks(self)
          end
        end
      end
    end
  end
end

module Elasticsearch
  module YamlTestSuite
    $results = {}
    $stash   = {}

    module Utils
      def titleize(word)
        word.to_s.gsub(/[^\w]+/, ' ').gsub(/\b('?[a-z])/) { $1.capitalize }
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

        STDERR.puts "ARGUMENTS: #{arguments.inspect}" if ENV['DEBUG']

        $results[test.hash] = namespace.reduce($client) do |memo, current|
          unless current == namespace.last
            memo = memo.send(current)
          else
            arguments ? memo = memo.send(current, arguments) : memo = memo.send(current)
          end
          memo
        end
      end

      def evaluate(test, property)
        property.gsub(/\\\./, '_____').split('.').reduce($results[test.hash]) do |memo, attr|
          if memo
            attr = attr.gsub(/_____/, '.') if attr
            memo = memo.is_a?(Hash) ? memo[attr] : memo[attr.to_i]
          end
          memo
        end
      end

      def in_context(name, &block)
        klass = Class.new(YamlTestCase)
        Object::const_set "%sTest" % name.split(/\s/).map { |d| d.capitalize }.join('').gsub(/[^\w]+/, ''), klass
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
        if skip
          min, max = skip['skip']['version'].split('-').map(&:strip)
          if min <= $es_version && max >= $es_version
            return skip['skip']['reason'] ? skip['skip']['reason'] : true
          end
        end
        return false
      end

      extend self
    end

    class YamlTestCase < ::Test::Unit::TestCase; end
  end
end

include Elasticsearch::YamlTestSuite

PATH    = Pathname(ENV['SPEC'] || File.expand_path('../../../spec/test', __FILE__))
suites  = Dir.glob(PATH.join('*')).map { |d| Pathname(d) }
suites  = suites.select { |s| s.to_s =~ Regexp.new(ENV['FILTER']) } if ENV['FILTER']

suites.each do |suite|
  name = Elasticsearch::YamlTestSuite::Utils.titleize(suite.basename)

  Elasticsearch::YamlTestSuite::Runner.in_context name do

    # --- Register context setup -------------------------------------------
    #
    setup do
      $client.indices.delete index: '_all'
      $results = {}
      $stash   = {}
    end

    # --- Register context teardown ----------------------------------------
    #
    teardown do
      $client.indices.delete index: '_all'
    end

    files = Dir[suite.join('*.{yml,yaml}')]
    files.each do |file|

      tests = YAML.load_documents File.new(file)

      # Extract setup actions
      setup_actions = tests.select { |t| t['setup'] }.first['setup'] rescue []

      # Remove setup actions from tests
      tests = tests.reject { |t| t['setup'] }

      # Add setup actions to each individual test
      tests.each { |t| t[t.keys.first] << { 'setup' => setup_actions } }

      tests.each do |test|
        context '' do
          test_name = test.keys.first
          actions   = test.values.first

          if reason = Runner.skip?(actions)
            STDOUT.puts "#{ANSI.ansi('SKIP', :yellow)}: [#{name}] #{test_name} (Reason: #{reason})"
            next
          end

          # --- Register test setup -------------------------------------------
          setup do
            actions.select { |a| a['setup'] }.first['setup'].each do |action|
              api, arguments = action['do'].to_a.first
              arguments      = Utils.symbolize_keys(arguments)
              Runner.perform_api_call((test.to_s + '___setup'), api, arguments)
            end
          end

          # --- Register test method ------------------------------------------
          should test_name do
            actions.each do |action|
              STDERR.puts "ACTION: #{action.inspect}" if ENV['DEBUG']

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
                    if catch_exception
                      STDERR.puts "CATCH '#{catch_exception}': #{e.inspect}" if ENV['DEBUG']
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
                  STDERR.puts "CHECK: Expected '#{property}' to be true, is: #{result.inspect}" if ENV['DEBUG']
                  assert(result, "Property '#{property}' should be true, is: #{result.inspect}")

                when property = action['is_false']
                  result = Runner.evaluate(test, property)
                  STDERR.puts "CHECK: Expected '#{property}' to be false, is: #{result.inspect}" if ENV['DEBUG']
                  assert( !!! result, "Property '#{property}' should be false, is: #{result.inspect}")

                when a = action['match']
                  property, value = a.to_a.first

                  value  = Runner.fetch_or_return(value)
                  result = Runner.evaluate(test, property)
                  STDERR.puts "CHECK: Expected '#{property}' to be '#{value}', is: #{result.inspect}" if ENV['DEBUG']
                  assert_equal(value, result)

                when a = action['length']
                  property, value = a.to_a.first

                  result = Runner.evaluate(test, property)
                  length = result.size
                  STDERR.puts "CHECK: Expected '#{property}' to be #{value}, is: #{length.inspect}" if ENV['DEBUG']
                  assert_equal(value, length)

                when a = action['lt'] || action['gt']
                  next
                  property, value = a.to_a.first
                  operator        = action['lt'] ? '<' : '>'

                  result  = Runner.evaluate(test, property)
                  message = "Expected '#{property}' to be #{operator} #{value}, is: #{result.inspect}"

                  STDERR.puts "CHECK: #{message}" if ENV['DEBUG']
                  # operator == 'less than' ? assert(value.to_f < result.to_f, message) : assert(value.to_f > result.to_f, message)
                  assert_operator result, operator.to_sym, value.to_i

                when stash = action['set']
                  property, variable = stash.to_a.first
                  result  = Runner.evaluate(test, property)
                  STDERR.puts "STASH: '$#{variable}' => #{result.inspect}" if ENV['DEBUG']
                  Runner.set variable, result
              end
            end
          end
        end
      end
    end

  end

end
