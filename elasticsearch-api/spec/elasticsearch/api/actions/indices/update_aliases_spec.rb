require 'spec_helper'

describe 'client.cluster#update_aliases' do

  let(:expected_args) do
    [
        'POST',
        '_aliases',
        params,
        body,
        nil
    ]
  end

  let(:body) do
    { actions: [] }
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.update_aliases(body: { actions: [] })).to eq({})
  end

  context 'when a body is not specified' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.indices.update_aliases
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when parameters are specified' do

    let(:params) do
      { timeout: '1s' }
    end

    it 'performs the request' do
      expect(client_double.indices.update_aliases(timeout: '1s', body: { actions: [] })).to eq({})
    end
  end
end
