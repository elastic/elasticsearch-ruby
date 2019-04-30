require 'spec_helper'

describe 'client#suggest' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        body
    ]
  end

  let(:url) do
    '_suggest'
  end

  let(:params) do
    {}
  end

  let(:body) do
    {}
  end

  it 'performs the request' do
    expect(client_double.suggest(body: {})).to eq({})
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_suggest'
    end

    it 'performs the request' do
      expect(client_double.suggest(index: 'foo', body: {}))
    end
  end

  context 'when there are URL params specified' do

    let(:url) do
      'foo/_suggest'
    end

    let(:params) do
      { routing: 'abc123' }
    end

    it 'performs the request' do
      expect(client_double.suggest(index: 'foo', routing: 'abc123', body: {}))
    end
  end

  context 'when the request must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_suggest'
    end

    it 'performs the request' do
      expect(client_double.suggest(index: 'foo^bar', body: {}))
    end
  end

  context 'when the request definition is specified in the body' do

    let(:body) do
      { my_suggest: { text: 'test' } }
    end

    it 'performs the request' do
      expect(client_double.suggest(body: { my_suggest: { text: 'test' } } ))
    end
  end
end
