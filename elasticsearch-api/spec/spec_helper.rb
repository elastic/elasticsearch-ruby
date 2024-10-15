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
if ENV['COVERAGE'] && ENV['CI'].nil?
  require 'simplecov'
  SimpleCov.start { add_filter %r{^/test|spec/} }
end

if defined?(JRUBY_VERSION)
  require 'pry-nav'
else
  require 'debug'
end
require 'yaml'
require 'active_support/isolated_execution_state' unless RUBY_VERSION < '2.7.0'
require 'jbuilder'
require 'jsonify'
require 'elasticsearch'
require 'elasticsearch-api'
require 'openssl'
require 'logger'

tracer = ::Logger.new(STDERR)
tracer.formatter = lambda { |s, d, p, m| "#{m.gsub(/^.*$/) { |n| '   ' + n } }\n" }

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
  config.filter_run_excluding skip: true
  if defined?(JRUBY_VERSION)
    config.add_formatter('RSpec::Core::Formatters::HtmlFormatter', "tmp/elasticsearch-#{ENV['TEST_SUITE']}-jruby-#{JRUBY_VERSION}.html")
  else
    config.add_formatter('RSpec::Core::Formatters::HtmlFormatter', "tmp/elasticsearch-#{ENV['TEST_SUITE']}-#{RUBY_VERSION}.html")
  end
  if ENV['BUILDKITE']
    require_relative "./rspec_formatter.rb"
    config.add_formatter('RSpecCustomFormatter')
  end
  config.color_mode = :on
end

class NotFound < StandardError; end
