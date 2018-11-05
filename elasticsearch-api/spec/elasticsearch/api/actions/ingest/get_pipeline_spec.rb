require 'spec_helper'

describe 'client.ingest#get_pipeline' do

  let(:expected_args) do
    [
        'GET',
        url,
        {},
        nil,
        nil
    ]
  end

  let(:url) do
    '_ingest/pipeline/foo'
  end

  it 'performs the request' do
    expect(client_double.ingest.get_pipeline(id: 'foo')).to eq({})
  end

  context 'when the path must be URL-escaped' do

    let(:url) do
      '_ingest/pipeline/foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.ingest.get_pipeline(id: 'foo^bar')).to eq({})
    end
  end
end
