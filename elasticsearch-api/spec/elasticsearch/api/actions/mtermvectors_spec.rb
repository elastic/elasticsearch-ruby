require 'spec_helper'

describe 'client#mtermvectors' do

  let(:expected_args) do
    [
        'GET',
        'my-index/my-type/_mtermvectors',
        { },
        body
    ]
  end

  let(:body) do
    { ids: [1, 2, 3] }
  end

  it 'performs the request' do
    expect(client_double.mtermvectors(index: 'my-index', type: 'my-type', body: { ids: [1, 2, 3] })).to eq({})
  end

  context 'when a list of ids is passed instead of a body' do

    it 'performs the request' do
      expect(client_double.mtermvectors(index: 'my-index', type: 'my-type', ids: [1, 2, 3])).to eq({})
    end
  end
end
