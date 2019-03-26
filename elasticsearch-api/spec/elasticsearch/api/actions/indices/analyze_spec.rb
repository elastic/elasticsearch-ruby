require 'spec_helper'

describe 'client.indices#analyze' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body,
        nil
    ]
  end

  let(:body) do
    nil
  end

  let(:url) do
    '_analyze'
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.analyze).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_analyze'
    end

    let(:params) do
      { index: 'foo' }
    end

    it 'performs the request' do
      expect(client_double.indices.analyze(index: 'foo')).to eq({})
    end
  end

  context 'when a body is specified' do

    let(:body) do
      'foo'
    end

    it 'performs the request' do
      expect(client_double.indices.analyze(body: 'foo')).to eq({})
    end
  end
end
