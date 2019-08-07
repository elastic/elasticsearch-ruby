# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe Elasticsearch::Transport::Transport::Base do

  context 'when a host is printed in a logged message' do

    shared_examples_for 'a redacted string' do

      let(:client) do
        Elasticsearch::Transport::Client.new(arguments)
      end

      let(:logger) do
        double('logger', error?: true, error: '')
      end

      it 'does not include the password in the logged string' do
        expect(logger).not_to receive(:error).with(/secret_password/)
        expect {
          client.cluster.stats
        }.to raise_exception(Faraday::ConnectionFailed)
      end

      it 'replaces the password with the string \'REDACTED\'' do
        expect(logger).to receive(:error).with(/REDACTED/)
        expect {
          client.cluster.stats
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end

    context 'when the user and password are provided as separate arguments' do

      let(:arguments) do
        { hosts: 'fake',
          logger: logger,
          password: 'secret_password',
          user: 'test' }
      end

      it_behaves_like 'a redacted string'
    end

    context 'when the user and password are provided in the string URI' do

      let(:arguments) do
        { hosts: 'http://test:secret_password@fake.com',
          logger: logger }
      end

      it_behaves_like 'a redacted string'
    end

    context 'when the user and password are provided in the URI object' do

      let(:arguments) do
        { hosts: URI.parse('http://test:secret_password@fake.com'),
          logger: logger }
      end

      it_behaves_like 'a redacted string'
    end
  end

  context 'when reload_on_failure is true and and hosts are unreachable' do

    let(:client) do
      Elasticsearch::Transport::Client.new(arguments)
    end

    let(:arguments) do
      {
          hosts: ['http://unavabilable:9200', 'http://unavabilable:9201'],
          reload_on_failure: true,
          sniffer_timeout: 5
      }
    end

    it 'raises an exception' do
      expect {
        client.info
      }.to raise_exception(Faraday::ConnectionFailed)
    end
  end

  context 'when the client has `retry_on_failure` set to an integer' do

    let(:client) do
      Elasticsearch::Transport::Client.new(arguments)
    end

    let(:arguments) do
      {
          hosts: ['http://unavabilable:9200', 'http://unavabilable:9201'],
          retry_on_failure: 2
      }
    end

    context 'when `perform_request` is called without a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).exactly(3).times.and_call_original
      end

      it 'uses the client `retry_on_failure` value' do
        expect {
          client.transport.perform_request('GET', '/info')
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end

    context 'when `perform_request` is called with a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).exactly(6).times.and_call_original
      end

      it 'uses the option `retry_on_failure` value' do
        expect {
          client.transport.perform_request('GET', '/info', {}, nil, nil, retry_on_failure: 5)
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end
  end

  context 'when the client has `retry_on_failure` set to true' do

    let(:client) do
      Elasticsearch::Transport::Client.new(arguments)
    end

    let(:arguments) do
      {
          hosts: ['http://unavabilable:9200', 'http://unavabilable:9201'],
          retry_on_failure: true
      }
    end

    context 'when `perform_request` is called without a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).exactly(4).times.and_call_original
      end

      it 'uses the default `MAX_RETRIES` value' do
        expect {
          client.transport.perform_request('GET', '/info')
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end

    context 'when `perform_request` is called with a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).exactly(6).times.and_call_original
      end

      it 'uses the option `retry_on_failure` value' do
        expect {
          client.transport.perform_request('GET', '/info', {}, nil, nil, retry_on_failure: 5)
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end
  end

  context 'when the client has `retry_on_failure` set to false' do

    let(:client) do
      Elasticsearch::Transport::Client.new(arguments)
    end

    let(:arguments) do
      {
          hosts: ['http://unavabilable:9200', 'http://unavabilable:9201'],
          retry_on_failure: false
      }
    end

    context 'when `perform_request` is called without a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).once.and_call_original
      end

      it 'does not retry' do
        expect {
          client.transport.perform_request('GET', '/info')
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end

    context 'when `perform_request` is called with a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).exactly(6).times.and_call_original
      end

      it 'uses the option `retry_on_failure` value' do
        expect {
          client.transport.perform_request('GET', '/info', {}, nil, nil, retry_on_failure: 5)
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end
  end

  context 'when the client has no `retry_on_failure` set' do

    let(:client) do
      Elasticsearch::Transport::Client.new(arguments)
    end

    let(:arguments) do
      {
          hosts: ['http://unavabilable:9200', 'http://unavabilable:9201'],
      }
    end

    context 'when `perform_request` is called without a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).exactly(1).times.and_call_original
      end

      it 'does not retry' do
        expect {
          client.transport.perform_request('GET', '/info')
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end

    context 'when `perform_request` is called with a `retry_on_failure` option value' do

      before do
        expect(client.transport).to receive(:get_connection).exactly(6).times.and_call_original
      end

      it 'uses the option `retry_on_failure` value' do
        expect {
          client.transport.perform_request('GET', '/info', {}, nil, nil, retry_on_failure: 5)
        }.to raise_exception(Faraday::ConnectionFailed)
      end
    end
  end
end
