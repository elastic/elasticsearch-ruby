require 'spec_helper'

describe 'client#msearch_template' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        body,
        headers
    ]
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  let(:headers) do
    { 'Content-Type' => 'application/x-ndjson' }
  end

  let(:url) do
    '_msearch/template'
  end

  context 'when a body is provided as a document' do

    let(:body) do
      <<-PAYLOAD.gsub(/^\s+/, '')
            {"index":"foo"}
            {"inline":{"query":{"match":{"foo":"{{q}}"}}},"params":{"q":"foo"}}
            {"index":"bar"}
            {"id":"query_foo","params":{"q":"foo"}}
      PAYLOAD
    end

    it 'performs the request' do
      expect(client_double.msearch_template(body: [
          { index: 'foo' },
          { inline: { query: { match: { foo: '{{q}}' } } }, params: { q: 'foo' } },
          { index: 'bar' },
          { id: 'query_foo', params: { q: 'foo' } }
      ])).to eq({})
    end
  end

  context 'when a body is provided as a string' do

    let(:body) do
      %Q|{"foo":"bar"}\n{"moo":"lam"}|
    end

    it 'performs the request' do
      expect(client_double.msearch_template(body: %Q|{"foo":"bar"}\n{"moo":"lam"}|)).to eq({})
    end
  end

  context 'when an index is provided' do

    let(:url) do
      'foo/_msearch/template'
    end

    let(:body) do
      ''
    end

    it 'performs the request' do
      expect(client_double.msearch_template(index: 'foo', body: []))
    end
  end
end
