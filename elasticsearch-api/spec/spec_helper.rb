# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

if defined?(JRUBY_VERSION)
  require 'pry-nav'
else
  require 'pry-byebug'
end
require 'yaml'
require 'jbuilder'
require 'jsonify'
require 'elasticsearch'
require 'elasticsearch-transport'
require 'elasticsearch-api'

require 'ansi'
tracer = ::Logger.new(STDERR)
tracer.formatter = lambda { |s, d, p, m| "#{m.gsub(/^.*$/) { |n| '   ' + n }.ansi(:faint)}\n" }

unless defined?(ELASTICSEARCH_URL)
  ELASTICSEARCH_URL = ENV['ELASTICSEARCH_URL'] ||
                        ENV['TEST_ES_SERVER'] ||
                        "localhost:#{(ENV['TEST_CLUSTER_PORT'] || 9200)}"
end

DEFAULT_CLIENT = Elasticsearch::Client.new(host: ELASTICSEARCH_URL,
                                           tracer: (tracer unless ENV['QUIET']))

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
  config.add_formatter('documentation')
  config.add_formatter('RspecJunitFormatter', 'tmp/elasticsearch-api-junit.xml')
  config.color_mode = :on
end

class NotFound < StandardError; end
