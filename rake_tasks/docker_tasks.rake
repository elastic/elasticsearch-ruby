# frozen_string_literal: true

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

require 'mkmf' # For find_executable

namespace :es do
  desc <<~DOC
    Start Elasticsearch in a Docker container.

    Default:
      rake es:start[version]
    E.g.:
      rake es:start[9.x-SNAPSHOT]

    To start the container with Platinum, pass it in as a parameter:
      rake es:start[9.x-SNAPSHOT,platinum]
  DOC
  task :start, [:version, :suite] do |_, params|
    abort 'Docker not installed' unless find_executable 'docker'
    abort 'You need to set a version, e.g. rake docker:start[9.x-SNAPSHOT]' unless params[:version]

    test_suite = params[:suite] || 'free'
    system("STACK_VERSION=#{params[:version]} TEST_SUITE=#{test_suite} ./.buildkite/run-elasticsearch.sh")
  end

  desc <<~DOC
    Start Elasticsearch docker container (shortcut), reads STACK_VERSION from buildkite pipeline
  DOC
  task :up do
    version = File.read('./.buildkite/pipeline.yml')
                  .split("\n")
                  .select { |a| a.include? 'STACK_VERSION' }
                  .first
                  .strip
                  .gsub('STACK_VERSION: ', '')
    Rake.application.invoke_task("es:start[#{version}, platinum]")
  end
end
