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

describe 'client.indices#delete' do

  let(:expected_args) do
    [
        'DELETE',
        url,
        params,
        nil,
        {}
    ]
  end

  let(:params) do
    {}
  end

  let(:url) do
    'foo'
  end

  it 'performs the request' do
    expect(client_double.indices.delete(index: 'foo')).to eq({})
  end

  context 'when more than one index is specified' do

    let(:url) do
      'foo,bar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete(index: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when params are specified' do

    let(:params) do
      { timeout: '1s' }
    end

    it 'performs the request' do
      expect(client_double.indices.delete(index: 'foo', timeout: '1s')).to eq({})
    end
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.indices.delete(index: 'foo^bar')).to eq({})
    end
  end

  context 'when a NotFound exception is raised by the request' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises the exception' do
      expect {
        client.indices.delete(index: 'foo')
      }.to raise_exception(NotFound)
    end
  end

  context 'when the ignore parameter is specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'ignores the code' do
      expect(client.indices.delete(index: 'foo', ignore: 404)).to eq(false)
    end
  end
end
