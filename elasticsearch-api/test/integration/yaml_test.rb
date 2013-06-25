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

PATH    = Pathname(ENV['SPEC'] || File.expand_path('../../../spec/test', __FILE__))
suites  = Dir.glob(PATH.join('*')).map { |d| Pathname(d) }

require 'test_helper'
require 'test/unit'
require 'shoulda/context'

module Elasticsearch
  module YamlTestSuite
    $results = {}

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

        $results[test.hash] = namespace.reduce($client) do |memo, current|
          unless current == namespace.last
            memo = memo.send(current)
          else
            arguments ? memo = memo.send(current, arguments) : memo = memo.send(current)
          end
          memo
        end
      end

      def evaluate(test, predicate)
        predicate.split('.').reduce($results[test.hash]) do |memo, attr|
          memo = memo.is_a?(Hash) ? memo[attr] : memo[attr.to_i]
          memo
        end
      end

      def in_context(name, &block)
        klass = Class.new(YamlTestCase)
        Object::const_set "%sTest" % name.split(/\s/).map { |d| d.capitalize }.join('').gsub(/[^\w]+/, ''), klass
        klass.context name, &block
      end

      def has_assertions?(actions)
        assertions = lambda { |d| d =~ /(is|length|match)/ }

        case
          when actions.is_a?(Array)
            actions.map { |d| d.keys }.flatten.any? &assertions
          when actions.is_a?(Hash)
            actions.keys.any? &assertions
        else
          raise RuntimeError, "Please pass Array or Hash, #{actions.class} given"
        end
      end

      extend self
    end

    class YamlTestCase < ::Test::Unit::TestCase; end
  end
end

$client.indices.delete index: 'test' rescue nil

suites.each do |suite|
  name = Elasticsearch::YamlTestSuite::Utils.titleize(suite.basename)

  Elasticsearch::YamlTestSuite::Runner.in_context name do

    files = Dir[suite.join('*.{yml,yaml}')]
    files.each do |file|

      tests = YAML.load_documents File.new(file)
      tests.each do |test|

        test_name = test.keys.first
        actions   = test.values.first

        # --- Register test setup -------------------------------------------
        #
        define_method :setup do
          $client.indices.delete index: '_all'

          actions.reject { |a| Elasticsearch::YamlTestSuite::Runner.has_assertions? a }.each do |action|
            STDERR.puts "SETUP: #{action.inspect}" if ENV['DEBUG']
            if action['do']
              api, arguments = action['do'].to_a.first
              arguments = Elasticsearch::YamlTestSuite::Utils.symbolize_keys(arguments)
              Elasticsearch::YamlTestSuite::Runner.perform_api_call(test, api, arguments)
            end
          end
        end

        # --- Register test teardown ----------------------------------------
        #
        define_method :teardown do
          $client.indices.delete index: '_all'
        end

        # --- Register test method ------------------------------------------
        define_method "test: [#{name}] " + test_name do
          actions.each do |action|
            STDERR.puts "ACTION: #{action.inspect}" if ENV['DEBUG']

            case

              # --- Perform action ------------------------------------------
              #
              when action['do']
                catch_exception = action['do'].delete('catch') if action['do']
                api, arguments = action['do'].to_a.first
                arguments      = Elasticsearch::YamlTestSuite::Utils.symbolize_keys(arguments)

                begin
                  $results[test.hash] = Elasticsearch::YamlTestSuite::Runner.perform_api_call(test, api, arguments)
                rescue Exception => e
                  if catch_exception
                    # STDERR.puts "Got: #{e.inspect}"
                    assert_match Regexp.new(catch_exception.tr('/', '')), e.message
                  else
                    raise e
                  end
                end

              # --- Evaluate predicate --------------------------------------
              #
              when action['is'] || action['length']
                a = action['is'] || action['length']
                predicate, value = a.is_a?(Hash) ? a.to_a.first : [nil, a]

                if predicate
                  result = Elasticsearch::YamlTestSuite::Runner.evaluate(test, predicate)
                  action['length'] ? assert_equal(value, result.size) : assert_equal(value, result)
                else
                  action['length'] ? assert_equal(value, $results[test.hash].size) : assert_equal(value, $results[test.hash])
                end
            end
          end
        end
      end
    end

  end

end
