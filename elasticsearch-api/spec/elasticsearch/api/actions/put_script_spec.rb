# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#put_script' do
  let(:url) do
    '_scripts/foo'
  end

  context 'when the lang parameter is provided' do
    let(:expected_args) do
      [
        'PUT',
        url,
        {},
        { script: 'bar', lang: 'groovy' },
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.put_script(id: 'foo', body: { script: 'bar', lang: 'groovy' })).to eq({})
    end
  end

  context 'when the lang parameter is not provided' do
    let(:expected_args) do
      [
        'PUT',
        url,
        {},
        { script: 'bar' },
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.put_script(id: 'foo', body: { script: 'bar' })).to eq({})
    end
  end
end
