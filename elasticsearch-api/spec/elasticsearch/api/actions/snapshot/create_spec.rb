require 'spec_helper'

describe 'client.snapshot#create' do

  let(:expected_args) do
    [
        'PUT',
        '_snapshot/foo/bar',
        {},
        {},
        nil
    ]
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :repository argument' do
    expect {
      client.snapshot.create(snapshot: 'bar', body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :snapshot argument' do
    expect {
      client.snapshot.create(repository: 'foo', body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.snapshot.create(repository: 'foo', snapshot: 'bar', body: {})).to eq({})
  end
end
