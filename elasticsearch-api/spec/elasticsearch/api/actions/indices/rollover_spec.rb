require 'spec_helper'

describe 'client.cluster#rollover' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        body,
        nil
    ]
  end

  let(:url) do
    'foo/_rollover'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.rollover(alias: 'foo')).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_rollover/bar'
    end

    it 'performs the request' do
      expect(client_double.indices.rollover(alias: 'foo', new_index: 'bar')).to eq({})
    end
  end
end
