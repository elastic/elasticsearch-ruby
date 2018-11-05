require 'spec_helper'

describe 'client.ingest#put_pipeline' do

  let(:expected_args) do
    [
        'PUT',
        url,
        {},
        {},
        nil
    ]
  end

  let(:url) do
    '_ingest/pipeline/foo'
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :id argument' do
    expect {
      client.ingest.put_pipeline
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.ingest.put_pipeline(id: 'foo', body: {})).to eq({})
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      '_ingest/pipeline/foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.ingest.put_pipeline(id: 'foo^bar', body: {})).to eq({})
    end
  end
end
