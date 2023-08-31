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
require 'webmock/rspec'

describe 'Elasticsearch: Validation' do
  let(:host) { 'http://localhost:9200' }
  let(:count_request_stub) do
    stub_request(:get, "#{host}/_count")
      .to_return(status: status, body: nil, headers: headers)
  end
  let(:status) { 200 }
  let(:body) { nil }
  let(:headers) { {} }
  let(:client) { Elasticsearch::Client.new }

  context 'When Elasticsearch replies with status 401' do
    let(:status) { 401 }

    it 'Verifies the request but shows a warning' do
      stderr      = $stderr
      fake_stderr = StringIO.new
      $stderr     = fake_stderr
      expect(client.instance_variable_get('@verified')).to be false
      count_request_stub
      expect do
        client.count
      end.to raise_error Elastic::Transport::Transport::Errors::Unauthorized
      expect(client.instance_variable_get('@verified')).to be true

      fake_stderr.rewind
      expect(fake_stderr.string).to eq("#{Elasticsearch::SECURITY_PRIVILEGES_VALIDATION_WARNING}\n")
    ensure
      $stderr = stderr
    end
  end

  context 'When Elasticsearch replies with status 403' do
    let(:status) { 403 }

    it 'Verifies the request but shows a warning' do
      stderr      = $stderr
      fake_stderr = StringIO.new
      $stderr     = fake_stderr

      expect(client.instance_variable_get('@verified')).to be false
      count_request_stub
      expect do
        client.count
      end.to raise_error Elastic::Transport::Transport::Errors::Forbidden
      expect(client.instance_variable_get('@verified')).to be true

      fake_stderr.rewind
      expect(fake_stderr.string).to eq("#{Elasticsearch::SECURITY_PRIVILEGES_VALIDATION_WARNING}\n")
    ensure
      $stderr = stderr
    end
  end

  context 'When Elasticsearch replies with status 413' do
    let(:status) { 413 }

    it 'Verifies the request and shows a warning' do
      stderr      = $stderr
      fake_stderr = StringIO.new
      $stderr     = fake_stderr

      expect(client.instance_variable_get('@verified')).to be false
      count_request_stub
      expect do
        client.count
      end.to raise_error Elastic::Transport::Transport::Errors::RequestEntityTooLarge
      expect(client.instance_variable_get('@verified')).to be true

      fake_stderr.rewind
      expect(fake_stderr.string.delete("\n"))
        .to eq(Elasticsearch::SECURITY_PRIVILEGES_VALIDATION_WARNING)
    ensure
      $stderr = stderr
    end
  end

  context 'When Elasticsearch replies with status 503' do
    let(:status) { 503 }
    let(:body) { {}.to_json }

    it 'Does not verify the request and shows a warning' do
      stderr      = $stderr
      fake_stderr = StringIO.new
      $stderr     = fake_stderr

      expect(client.instance_variable_get('@verified')).to be false
      count_request_stub
      expect do
        client.count
      end.to raise_error Elastic::Transport::Transport::Errors::ServiceUnavailable
      expect(client.instance_variable_get('@verified')).to be false

      fake_stderr.rewind
      expect(fake_stderr.string)
        .to eq(
              <<~MSG
            The client is unable to verify that the server is \
            Elasticsearch. Some functionality may not be compatible \
            if the server is running an unsupported product.
          MSG
            )
    ensure
      $stderr = stderr
    end
  end

  context 'When the header is present' do
    let(:headers) { { 'X-Elastic-Product' => 'Elasticsearch' } }

    it 'Makes requests and passes validation' do
      expect(client.instance_variable_get('@verified')).to be false
      count_request_stub
      client.count
      expect(client.instance_variable_get('@verified')).to be true
    end
  end

  context 'When the header is not present' do
    it 'Fails validation' do
      expect(client.instance_variable_get('@verified')).to be false
      stub_request(:get, "#{host}/_cluster/health")
        .to_return(status: status, body: nil, headers: {})
      expect { client.cluster.health }.to raise_error Elasticsearch::UnsupportedProductError, Elasticsearch::NOT_ELASTICSEARCH_WARNING
      expect(client.instance_variable_get('@verified')).to be false
    end
  end
end
