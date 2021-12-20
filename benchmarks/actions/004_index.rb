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

require_relative '../lib/benchmarks'

Benchmarks.register \
  action: 'index',
  category: 'core',
  warmups: 100,
  repetitions: 10_000,
  setup: Proc.new { |runner|
    runner.runner_client.indices.delete(index: 'test-bench-index', ignore: 404)
    runner.runner_client.indices.create(index: 'test-bench-index')
    runner.runner_client.cluster.health(wait_for_status: 'yellow')
  },
  measure: Proc.new { |n, runner|
    doc_path = Benchmarks.data_path.join('small/document.json')
    raise RuntimeError.new("Document at #{doc_path} not found") unless doc_path.exist?
    response = runner.runner_client.index index: 'test-bench-index', id: "%04d-%04d" % [n, rand(1..1000)], body: doc_path.open.read
    raise RuntimeError.new("Incorrect response: #{response}") unless response["result"] == "created"
  }
