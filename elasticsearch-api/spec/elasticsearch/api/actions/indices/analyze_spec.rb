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

  context 'when an url params are specified' do

    let(:params) do
      { text: 'foo', analyzer: 'bar' }
    end

    it 'performs the request' do
      expect(client_double.indices.analyze(text: 'foo', analyzer: 'bar')).to eq({})
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

  context 'when filters are specified' do

    let(:params) do
      { filters: 'foo,bar', text: 'Test', tokenizer: 'whitespace' }
    end

    it 'performs the request' do
      expect(client_double.indices.analyze(text: 'Test', tokenizer: 'whitespace', filters: ['foo,bar'])).to eq({})
    end
  end

  context 'when path must be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_analyze'
    end

    let(:params) do
      { text: 'Test', index: 'foo^bar' }
    end

    it 'performs the request' do
      expect(client_double.indices.analyze(index: 'foo^bar', text: 'Test')).to eq({})
    end
  end
end
