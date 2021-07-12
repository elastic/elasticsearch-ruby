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
require 'elasticsearch'
require 'webmock/rspec'

describe 'Elasticsearch: wrapper gem' do
  it 'requires all neccessary subgems' do
    expect(defined?(Elasticsearch::Client))
    expect(defined?(Elasticsearch::API))
  end

  it 'mixes the API into the client' do
    client = Elasticsearch::Client.new

    expect(client).to respond_to(:search)
    expect(client).to respond_to(:cluster)
    expect(client).to respond_to(:indices)
  end

  it 'can access the client transport' do
    client = Elasticsearch::Client.new
    expect(client.transport).to be_a(Elasticsearch::Transport::Client)
    expect(client.transport.transport).to be_a(Elasticsearch::Transport::Transport::HTTP::Faraday)
  end
end
