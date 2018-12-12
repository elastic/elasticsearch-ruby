# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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
