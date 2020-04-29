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

if defined?(JRUBY_VERSION)
  require 'pry-nav'
else
  require 'pry-byebug'
end
require 'ansi'
require 'elasticsearch'
require 'elasticsearch-api'
require 'elasticsearch-transport'
require 'jbuilder'
require 'jsonify'
require 'yaml'

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
  config.formatter = 'documentation'
  config.color = true
  config.add_formatter('RspecJunitFormatter', 'tmp/elasticsearch-api-junit.xml')
end

class NotFound < StandardError; end
