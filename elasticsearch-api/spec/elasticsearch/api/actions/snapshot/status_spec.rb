require 'spec_helper'

describe 'client.snapshot#status' do

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
    '_snapshot/_status'
  end

  it 'performs the request' do
    expect(client_double.snapshot.status).to eq({})
  end

  context 'when a repository and snapshot are specified' do

    let(:url) do
      '_snapshot/foo/bar/_status'
    end

    it 'performs the request' do
      expect(client_double.snapshot.status(repository: 'foo', snapshot: 'bar')).to eq({})
    end
  end
end
