# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#scroll' do
  context 'with scroll_id as a param' do
    let(:expected_args) do
      [
        'GET',
        '_search/scroll/cXVlcn...',
        {},
        nil,
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.scroll(scroll_id: 'cXVlcn...')).to eq({})
    end
  end

  context 'with scroll_id in the body' do
    let(:expected_args) do
      [
        'GET',
        '_search/scroll',
        {},
        { scroll_id: 'cXVlcn...' },
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.scroll(body: { scroll_id: 'cXVlcn...' })).to eq({})
    end
  end
end
