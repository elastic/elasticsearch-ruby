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
require 'test_helper'

if JRUBY
  require 'elasticsearch/transport/transport/http/manticore'

  class Elasticsearch::Transport::ClientManticoreIntegrationTest < Elasticsearch::Test::IntegrationTestCase
    context "Transport" do
      setup do
        @host, @port = ELASTICSEARCH_HOSTS.first.split(':')
      end

      shutdown do
        begin; Object.send(:remove_const, :Manticore); rescue NameError; end
      end

      should 'allow to customize the Faraday adapter to Manticore' do
        client = Elasticsearch::Transport::Client.new(
          transport_class: Elasticsearch::Transport::Transport::HTTP::Manticore,
          trace: true,
          hosts: [ { host: @host, port: @port } ]
        )
        response = client.perform_request 'GET', ''
        assert_respond_to(response.body, :to_hash)
      end
    end
  end
end
