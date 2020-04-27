# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#clear_scroll' do

  let(:expected_args) do
    [
      'DELETE',
      '_search/scroll/abc123',
      {},
      nil
    ]
  end

  it 'performs the request' do
    expect(client_double.clear_scroll(scroll_id: 'abc123')).to eq({})
  end

  context 'when a list of scroll ids is provided' do

    let(:expected_args) do
      [
          'DELETE',
          '_search/scroll/abc123,def456',
          {},
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.clear_scroll(scroll_id: ['abc123', 'def456'])).to eq({})
    end
  end
end
