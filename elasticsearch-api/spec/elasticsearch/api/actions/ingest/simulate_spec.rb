require 'spec_helper'

describe 'client.ingest#simulate' do

  let(:expected_args) do
    [
        'GET',
        url,
        {},
        {},
        nil
    ]
  end

  let(:url) do
    '_ingest/pipeline/_simulate'
  end

  it 'performs the request' do
    expect(client_double.ingest.simulate(body: {})).to eq({})
  end

  context 'when a pipeline id is provided' do

    let(:url) do
      '_ingest/pipeline/foo/_simulate'
    end

    it 'performs the request' do
      expect(client_double.ingest.simulate(id: 'foo', body: {})).to eq({})
    end
  end
end
