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
require 'mkmf'

namespace :docker do
  desc <<~DOC
    Start Elasticsearch in a Docker container.

    Default:
      rake docker:start[version]
    E.g.:
      rake docker:start[7.x-SNAPSHOT]

    To start the container with X-Pack, pass it in as a parameter:
      rake docker:start[7.x-SNAPSHOT,xpack]
  DOC
  task :start, [:version,:suite] do |_, params|
    abort 'Docker not installed' unless find_executable 'docker'
    abort 'You need to set a version, e.g. rake docker:start[7.x-SNAPSHOT]' unless params[:version]

    elasticsearch_suite = if ['xpack', 'x-pack'].include? :suite
                            'elasticsearch'
                          else
                            'elasticsearch-oss'
                          end
    system("ELASTICSEARCH_VERSION=#{elasticsearch_suite}:#{params[:version]} ./.ci/run-elasticsearch.sh")
  end
end
