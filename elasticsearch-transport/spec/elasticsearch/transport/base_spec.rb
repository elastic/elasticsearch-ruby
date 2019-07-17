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
end
