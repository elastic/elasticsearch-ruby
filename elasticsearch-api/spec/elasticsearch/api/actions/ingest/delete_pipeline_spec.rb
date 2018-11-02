require 'spec_helper'

describe 'client.ingest#delete_pipeline' do

  let(:expected_args) do
    [
        'DELETE',
        url,
        {},
        nil,
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
      client.ingest.delete_pipeline
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.ingest.delete_pipeline(id: 'foo')).to eq({})
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      '_ingest/pipeline/foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.ingest.delete_pipeline(id: 'foo^bar')).to eq({})
    end
  end
end
