# Licensed to Elasticsearch B.V. under one or more agreements.
# Elasticsearch B.V. licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information.

require_relative '../lib/benchmarks'

Benchmarks.register \
  action: 'get',
  category: 'core',
  warmups: 100,
  repetitions: 10_000,
  setup: Proc.new { |runner|
    runner.runner_client.indices.delete(index: 'test-bench-get', ignore: 404)
    runner.runner_client.index index: 'test-bench-get', id: '1', body: { title: 'Test' }
    runner.runner_client.cluster.health(wait_for_status: 'yellow')
    runner.runner_client.indices.refresh index: 'test-bench-get'
  },
  measure: Proc.new { |n, runner|
    response = runner.runner_client.get index: 'test-bench-get', id: '1'
    raise RuntimeError.new("Incorrect data: #{response}") unless response["_source"]["title"] == "Test"
  }
