require 'pry-nav'
require 'elasticsearch-transport'
require 'elasticsearch-api'

require 'jbuilder' if defined?(RUBY_VERSION) && RUBY_VERSION > '1.9'
require 'jsonify'

require 'ansi'
tracer = ::Logger.new(STDERR)
tracer.formatter = lambda { |s, d, p, m| "#{m.gsub(/^.*$/) { |n| '   ' + n }.ansi(:faint)}\n" }

RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'
JRUBY    = defined?(JRUBY_VERSION)

unless defined?(ELASTICSEARCH_URL)
  ELASTICSEARCH_URL = ENV['ELASTICSEARCH_URL'] || ENV['TEST_ES_SERVER'] || "localhost:#{(ENV['TEST_CLUSTER_PORT'] || 9200)}"
end

DEFAULT_CLIENT = Elasticsearch::Client.new host: ELASTICSEARCH_URL,
                                           tracer: (ENV['QUIET'] ? nil : tracer)

module HelperModule
  def self.included(context)

    context.let(:client_double) do
      Class.new { include Elasticsearch::API }.new.tap do |client|
        expect(client).to receive(:perform_request).with(*expected_args).and_return(response_double)
      end
    end

    context.let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |client|
        expect(client).to receive(:perform_request).with(*expected_args).and_return(response_double)
      end
    end

    context.let(:response_double) do
      double('response', status: 200, body: {}, headers: {})
    end
  end
end

RSpec.configure do |config|
  config.include(HelperModule)
  config.formatter = 'documentation'
  config.color = true
end

if ENV['COVERAGE'] && ENV['CI'].nil? && !RUBY_1_8
  require 'simplecov'
  SimpleCov.start { add_filter "/test|test_/" }
end

if ENV['CI'] && !RUBY_1_8
  require 'simplecov'
  require 'simplecov-rcov'
  SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
  SimpleCov.start { add_filter "/test|test_" }
end


unless ENV["NOTURN"] || RUBY_1_8
  require 'turn'

  if ENV['QUIET']
    Turn.config.format = :outline
    Turn.config.trace = 1
  end
end

class NotFound < StandardError; end

