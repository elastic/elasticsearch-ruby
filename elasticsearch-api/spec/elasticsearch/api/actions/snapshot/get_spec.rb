require 'spec_helper'

describe 'client.snapshot#get' do

  let(:expected_args) do
    [
        'GET',
        '_snapshot/foo/bar',
        {},
        nil,
        nil
    ]
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :snapshot argument' do
    expect {
      client.snapshot.get(repository: 'foo')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :repository argument' do
    expect {
      client.snapshot.get(snapshot: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.snapshot.get(repository: 'foo', snapshot: 'bar')).to eq({})
  end
end
