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
  let(:verify_request_stub) do
    stub_request(:get, host)
      .to_return(status: status, body: body, headers: headers)
  end
  let(:count_request_stub) do
    stub_request(:post, "#{host}/_count")
      .to_return(status: 200, body: nil, headers: {})
  end
  let(:status) { 200 }
  let(:body) { {}.to_json }
  let(:client) { Elasticsearch::Client.new }
  let(:headers) do
    { 'content-type' => 'json' }
  end

  def error_requests_and_expectations(message = Elasticsearch::NOT_ELASTICSEARCH_WARNING)
    expect { client.count }.to raise_error Elasticsearch::UnsupportedProductError, message
    assert_requested :get, host
    assert_not_requested :post, "#{host}/_count"
    expect { client.cluster.health }.to raise_error Elasticsearch::UnsupportedProductError, message
    expect(client.instance_variable_get('@verified')).to be false
    expect { client.cluster.health }.to raise_error Elasticsearch::UnsupportedProductError, message
  end

  def valid_requests_and_expectations
    expect(client.instance_variable_get('@verified')).to be false
    assert_not_requested :get, host

    client.count
    expect(client.instance_variable_get('@verified'))
    assert_requested :get, host
    assert_requested :post, "#{host}/_count"
  end

  context 'When Elasticsearch replies with status 401' do
    let(:status) { 401 }
    let(:body) { {}.to_json }

    it 'Verifies the request but shows a warning' do
      stderr      = $stderr
      fake_stderr = StringIO.new
      $stderr     = fake_stderr

      verify_request_stub
      count_request_stub

      valid_requests_and_expectations

      fake_stderr.rewind
      expect(fake_stderr.string).to eq("#{Elasticsearch::SECURITY_PRIVILEGES_VALIDATION_WARNING}\n")
    ensure
      $stderr = stderr
    end
  end

  context 'When Elasticsearch replies with status 403' do
    let(:status) { 403 }
    let(:body) { {}.to_json }

    it 'Verifies the request but shows a warning' do
      stderr      = $stderr
      fake_stderr = StringIO.new
      $stderr     = fake_stderr

      verify_request_stub
      count_request_stub

      valid_requests_and_expectations

      fake_stderr.rewind
      expect(fake_stderr.string).to eq("#{Elasticsearch::SECURITY_PRIVILEGES_VALIDATION_WARNING}\n")
    ensure
      $stderr = stderr
    end
  end

  context 'When the Elasticsearch version is >= 7.14' do
    context 'With a valid Elasticsearch response' do
      let(:body) { { 'version' => { 'number' => '7.14.0' } }.to_json }
      let(:headers) do
        {
          'X-Elastic-Product' => 'Elasticsearch',
          'content-type' => 'json'
        }
      end

      it 'Makes requests and passes validation' do
        verify_request_stub
        count_request_stub

        valid_requests_and_expectations
      end
    end

    context 'When the header is not present' do
      it 'Fails validation' do
        verify_request_stub

        expect(client.instance_variable_get('@verified')).to be false
        assert_not_requested :get, host

        error_requests_and_expectations
      end
    end
  end

  context 'When the Elasticsearch version is >= 7.14-SNAPSHOT' do
    context 'With a valid Elasticsearch response' do
      let(:body) { { 'version' => { 'number' => '7.14-SNAPSHOT' } }.to_json }
      let(:headers) do
        {
          'X-Elastic-Product' => 'Elasticsearch',
          'content-type' => 'json'
        }
      end

      it 'Makes requests and passes validation' do
        verify_request_stub
        count_request_stub

        valid_requests_and_expectations
      end
    end

    context 'When the header is not present' do
      it 'Fails validation' do
        verify_request_stub

        expect(client.instance_variable_get('@verified')).to be false
        assert_not_requested :get, host

        error_requests_and_expectations
      end
    end
  end

  context 'When the Elasticsearch version is >= 7.15-SNAPSHOT' do
    context 'With a valid Elasticsearch response' do
      let(:body) { { 'version' => { 'number' => '7.15-SNAPSHOT' } }.to_json }
      let(:headers) do
        {
          'X-Elastic-Product' => 'Elasticsearch',
          'content-type' => 'json'
        }
      end
      it 'Makes requests and passes validation' do
        verify_request_stub
        count_request_stub

        valid_requests_and_expectations
      end
    end

    context 'When the header is not present' do
      it 'Fails validation' do
        verify_request_stub

        expect(client.instance_variable_get('@verified')).to be false
        assert_not_requested :get, host

        error_requests_and_expectations
      end
    end
  end

  context 'When the version is 7.x-SNAPSHOT' do
    let(:body) { { 'version' => { 'number' => '7.x-SNAPSHOT' } }.to_json }

    context 'When the header is not present' do
      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations
      end
    end

    context 'With a valid Elasticsearch response' do
      let(:headers) do
        {
          'X-Elastic-Product' => 'Elasticsearch',
          'content-type' => 'json'
        }
      end

      it 'Makes requests and passes validation' do
        verify_request_stub
        count_request_stub

        valid_requests_and_expectations
      end
    end
  end

  context 'When Elasticsearch version is 7.4.0' do
    context 'When tagline is not present' do
      let(:body) { { 'version' => { 'number' => '7.4.0', 'build_flavor' => 'default' } }.to_json }

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations
      end
    end

    context 'When build flavor is not present' do
      let(:body) do
        {
          'version' => {
            'number' => '7.4.0'
          },
          'tagline' => Elasticsearch::YOU_KNOW_FOR_SEARCH
        }.to_json
      end

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations(Elasticsearch::NOT_SUPPORTED_ELASTICSEARCH_WARNING)
      end
    end

    context 'When the tagline is different' do
      let(:body) do
        {
          'version' => {
            'number' => '7.4.0',
            'build_flavor' => 'default'
          },
          'tagline' => 'You Know, for other stuff'
        }.to_json
      end

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations
      end
    end

    context 'With a valid Elasticsearch response' do
      let(:body) do
        {
          'version' => {
            'number' => '7.4.0',
            'build_flavor' => 'default'
          },
          'tagline' => 'You Know, for Search'
        }.to_json
      end

      it 'Makes requests and passes validation' do
        verify_request_stub
        count_request_stub

        valid_requests_and_expectations
      end
    end
  end

  context 'When Elasticsearch version is < 6.0.0' do
    let(:body) { { 'version' => { 'number' => '5.0.0' } }.to_json }

    it 'Raises an exception and client doesnae work' do
      verify_request_stub
      error_requests_and_expectations
    end
  end

  context 'When there is no version data' do
    let(:body) { {}.to_json }
    it 'Raises an exception and client doesnae work' do
      verify_request_stub
      error_requests_and_expectations
    end
  end

  context 'When Elasticsearch version is between 6.0.0 and 7.0.0' do
    context 'With an Elasticsearch valid response' do
      let(:body) do
        {
          'version' => {
            'number' => '6.8.10'
          },
          'tagline' => 'You Know, for Search'
        }.to_json
      end

      it 'Makes requests and passes validation' do
        verify_request_stub
        count_request_stub

        valid_requests_and_expectations
      end
    end

    context 'With no tagline' do
      let(:body) do
        { 'version' => { 'number' => '6.8.10' } }.to_json
      end

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations
      end
    end

    context 'When the tagline is different' do
      let(:body) do
        {
          'version' => {
            'number' => '6.8.10',
            'build_flavor' => 'default'
          },
          'tagline' => 'You Know, for Stuff'
        }.to_json
      end

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations
      end
    end
  end

  context 'When Elasticsearch version is between 7.0.0 and 7.14.0' do
    context 'With a valid Elasticsearch response' do
      let(:body) do
        {
          'version' => {
            'number' => '7.10.0',
            'build_flavor' => 'default'
          },
          'tagline' => 'You Know, for Search'
        }.to_json
      end

      it 'Makes requests and passes validation' do
        verify_request_stub
        count_request_stub

        valid_requests_and_expectations
      end
    end

    context 'When the tagline is not present' do
      let(:body) do
        {
          'version' => {
            'number' => '7.10.0',
            'build_flavor' => 'default'
          }
        }.to_json
      end

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations
      end
    end

    context 'When the tagline is different' do
      let(:body) do
        {
          'version' => {
            'number' => '7.10.0',
            'build_flavor' => 'default'
          },
          'tagline' => 'You Know, for other stuff'
        }.to_json
      end

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations
      end
    end

    context 'When the build_flavor is not present' do
      let(:body) do
        {
          'version' => {
            'number' => '7.10.0'
          },
          'tagline' => 'You Know, for Search'
        }.to_json
      end

      it 'Fails validation' do
        verify_request_stub
        count_request_stub

        error_requests_and_expectations(Elasticsearch::NOT_SUPPORTED_ELASTICSEARCH_WARNING)
      end
    end
  end

  context 'When doing a yaml content-type request' do
    let(:client) do
      Elasticsearch::Client.new(transport_options: {headers: { accept: 'application/yaml', content_type: 'application/yaml' }})
    end

    let(:headers) { { 'content-type' => 'application/yaml', 'X-Elastic-Product' => 'Elasticsearch' } }
    let(:body) { "---\nversion:\n  number: \"7.14.0-SNAPSHOT\"\n" }

    it 'validates' do
      verify_request_stub
      count_request_stub
      valid_requests_and_expectations
    end
  end
end
