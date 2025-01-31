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

require 'spec_helper'
require 'elastic/transport'

describe Elasticsearch::API::Response do
  let(:response_body) do
    {
      'name' => 'instance',
      'cluster_name' => 'elasticsearch-8-0-0',
      'version' => {
        'number' => '8.0.0',
        'build_flavor' => 'default'
      },
      'tagline' => 'You Know, for Search'
    }
  end
  let(:headers) do
    { 'Content-Type' => 'application/json'}
  end
  let(:es_response) do
    Elastic::Transport::Transport::Response.new(
      200,
      response_body,
      headers
    )
  end
  let(:response) { described_class.new(es_response) }

  it 'behaves like a Hash' do
    expect(response['name']).to eq 'instance'
    expect(response['version']).to eq({ 'number' => '8.0.0', 'build_flavor' => 'default' })
    expect(response.keys).to eq ['name', 'cluster_name', 'version', 'tagline']
    expect(response.respond_to?('map')).to be(true)
    expect(response.respond_to?('each')).to be(true)
    expect(response.respond_to?('size')).to be(true)
  end

  it 'returns a status' do
    expect(response.status).to eq 200
  end

  it 'returns the headers' do
    expect(response.headers).to eq headers
  end

  it 'returns the body which' do
    expect(response.body).to eq response_body
  end
end
