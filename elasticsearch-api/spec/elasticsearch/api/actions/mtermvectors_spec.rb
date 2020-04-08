# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#mtermvectors' do

  let(:expected_args) do
    [
        'GET',
        'my-index/_mtermvectors',
        { },
        body,
        {}
    ]
  end

  let(:body) do
    { ids: [1, 2, 3] }
  end

  it 'performs the request' do
    expect(client_double.mtermvectors(index: 'my-index', body: { ids: [1, 2, 3] })).to eq({})
  end

  context 'when a list of ids is passed instead of a body' do

    it 'performs the request' do
      expect(client_double.mtermvectors(index: 'my-index', ids: [1, 2, 3])).to eq({})
    end
  end
end
