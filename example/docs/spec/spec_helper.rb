# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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

RSpec.configure do |config|
  config.formatter = 'documentation'
  config.color = true
end
