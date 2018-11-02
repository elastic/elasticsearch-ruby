require 'spec_helper'

describe 'client.snapshot#delete' do

  let(:expected_args) do
    [
        'DELETE',
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
      client.snapshot.delete(repository: 'foo')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :repository argument' do
    expect {
      client.snapshot.delete(snapshot: 'bar')
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.snapshot.delete(repository: 'foo', snapshot: 'bar')).to eq({})
  end
end
