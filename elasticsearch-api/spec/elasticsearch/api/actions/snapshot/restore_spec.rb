require 'spec_helper'

describe 'client.snapshot#restore' do

  let(:expected_args) do
    [
        'POST',
        '_snapshot/foo/bar/_restore',
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
      client.snapshot.restore(repository: 'foo')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :repository argument' do
    expect {
      client.snapshot.restore(snapshot: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.snapshot.restore(repository: 'foo', snapshot: 'bar')).to eq({})
  end
end
