#!/usr/bin/env ruby

# Licensed to Elasticsearch B.V. under one or more agreements.
# Elasticsearch B.V. licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information.

require 'ansi/core'
require 'logger'
require 'patron'
require 'pathname'
require 'oj'

require_relative '../lib/benchmarks'

puts "Running benchmarks for elasticsearch-ruby@#{Elasticsearch::VERSION}".ansi(:bold,:underline)

config = {
  "ELASTICSEARCH_TARGET_URL"     => "",
  "ELASTICSEARCH_REPORT_URL"     => "",
  "DATA_SOURCE"                  => "",
  "BUILD_ID"                     => "",
  "TARGET_SERVICE_TYPE"          => "",
  "TARGET_SERVICE_NAME"          => "",
  "TARGET_SERVICE_VERSION"       => "",
  "TARGET_SERVICE_OS_FAMILY"     => "",
  "CLIENT_BRANCH"                => "",
  "CLIENT_COMMIT"                => "",
  "CLIENT_BENCHMARK_ENVIRONMENT" => ""
}

missing_keys = []

config.keys.each do |key|
  if ENV[key] && !ENV[key].to_s.empty?
    config[key] = ENV[key]
  else
    missing_keys << key
  end
end

unless missing_keys.empty?
puts "ERROR: Required environment variables [#{missing_keys.join(',')}] missing".ansi(:bold, :red)
  exit(1)
end

start = Time.now.utc

runner_client = Elasticsearch::Client.new(url: config["ELASTICSEARCH_TARGET_URL"])
report_client = Elasticsearch::Client.new(
  url: config["ELASTICSEARCH_REPORT_URL"],
  request_timeout: 5*60,
  retry_on_failure: 10
)
if ENV['DEBUG']
  logger = Logger.new(STDOUT)
  logger.level = Logger::INFO
  logger.formatter = proc { |s, d, p, m| "#{m}\n".ansi(:faint) }

  runner_client.transport.logger = logger
  report_client.transport.logger = logger
end

runner  = Benchmarks::Runner::Runner.new \
  build_id: config['BUILD_ID'],
  environment: config['CLIENT_BENCHMARK_ENVIRONMENT'],
  category: ENV['CLIENT_BENCHMARK_CATEGORY'].to_s,
  runner_client: runner_client,
  report_client: report_client,
  target: {
    service: {
      type: config['TARGET_SERVICE_TYPE'],
      name: config['TARGET_SERVICE_NAME'],
      version: config['TARGET_SERVICE_VERSION'],
      git: {
        branch: ENV['TARGET_SERVICE_GIT_BRANCH'],
        commit: ENV['TARGET_SERVICE_GIT_COMMIT']
      }
    },
    os: {
      family: config['TARGET_SERVICE_OS_FAMILY']
    }
  },
  runner: {
    service: {
      git: {
        branch: config['CLIENT_BRANCH'],
        commit: config['CLIENT_COMMIT']
      }
    }
  }

# ----- Run benchmarks --------------------------------------------------------

Benchmarks.data_path = Pathname(config["DATA_SOURCE"])
unless Benchmarks.data_path.exist?
  puts "ERROR: Data source at [#{Benchmarks.data_path}] not found".ansi(:bold, :red)
  exit(1)
end

Dir[File.expand_path("../../actions/*.rb", __FILE__)].each { |file| require file }

Benchmarks.actions.each do |b|
  next unless ENV['FILTER'].nil? or ENV['FILTER'].include? b.action

  runner.setup(&b.setup) if b.setup

  result = runner.measure(
    action:   b.action,
    category: b.category,
    warmups:  b.warmups,
    repetitions: b.repetitions,
    operations: b.operations,
    &b.measure).run!

  puts "  " +
       "[#{b.action}] ".ljust(16) +
       "#{b.repetitions}x ".ljust(10) +
       "mean=".ansi(:faint) +
       "#{coll = runner.stats.map(&:duration); ((coll.sum / coll.size.to_f)/1e+6).round}ms " +
       "runner=".ansi(:faint)+
       "#{runner.stats.any? { |s| s.outcome == 'failure' } ? 'failure' : 'success'  } ".ansi( runner.stats.none? { |s| s.outcome == 'failure' } ? :green : :red ) +
       "report=".ansi(:faint)+
       "#{result ? 'success' : 'failure' }".ansi( result ? :green : :red )
end

# -----------------------------------------------------------------------------

puts "Finished in #{(Time.mktime(0)+(Time.now.utc-start)).strftime("%H:%M:%S")}".ansi(:underline)
