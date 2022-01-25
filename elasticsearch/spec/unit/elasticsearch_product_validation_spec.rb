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
    stub_request(:get, "#{host}/_count")
      .to_return(status: 200, body: nil, headers: {})
  end
  let(:status) { 200 }
  let(:body) { {}.to_json }
  let(:client) { Elasticsearch::Client.new }
  let(:headers) do
    { 'content-type' => 'application/json' }
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
    assert_requested :get, "#{host}/_count"
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

  context 'When Elasticsearch replies with status 413' do
    let(:status) { 413 }
    let(:body) { {}.to_json }

    it 'Verifies the request and shows a warning' do
      stderr      = $stderr
      fake_stderr = StringIO.new
      $stderr     = fake_stderr

      expect(client.instance_variable_get('@verified')).to be false
      assert_not_requested :get, host
      verify_request_stub
      expect { client.info }.to raise_error Elastic::Transport::Transport::Errors::RequestEntityTooLarge
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
      assert_not_requested :get, host
      verify_request_stub
      expect { client.info }.to raise_error Elastic::Transport::Transport::Errors::ServiceUnavailable
      assert_not_requested :post, "#{host}/_count"
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


  context 'When the Elasticsearch version is >= 8.0.0' do
    context 'With a valid Elasticsearch response' do
      let(:body) { { 'version' => { 'number' => '8.0.0' } }.to_json }
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

  context 'When the Elasticsearch version is >= 8.1.0' do
    context 'With a valid Elasticsearch response' do
      let(:body) { { 'version' => { 'number' => '8.1.0' } }.to_json }
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


  context 'When the Elasticsearch version is 8.0.0.pre' do
    context 'With a valid Elasticsearch response' do
      let(:body) { { 'version' => { 'number' => '8.0.0.pre' } }.to_json }
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

  context 'When the version is 8.0.0-SNAPSHOT' do
    let(:body) { { 'version' => { 'number' => '8.0.0-SNAPSHOT' } }.to_json }

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

  context 'When Elasticsearch version is < 8.0.0' do
    let(:body) { { 'version' => { 'number' => '7.16.0' } }.to_json }

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

  context 'When doing a yaml content-type request' do
    let(:client) do
      Elasticsearch::Client.new(transport_options: {headers: { accept: 'application/yaml', content_type: 'application/yaml' }})
    end

    let(:headers) { { 'content-type' => 'application/yaml', 'X-Elastic-Product' => 'Elasticsearch' } }
    let(:body) { "---\nversion:\n  number: \"8.0.0-SNAPSHOT\"\n" }

    it 'validates' do
      verify_request_stub
      count_request_stub
      valid_requests_and_expectations
    end
  end
end
