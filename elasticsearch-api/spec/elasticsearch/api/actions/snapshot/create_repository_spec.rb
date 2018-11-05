require 'spec_helper'

describe 'client.snapshot#create_repository' do

  let(:expected_args) do
    [
        'PUT',
        '_snapshot/foo',
        {},
        {},
        nil
    ]
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :body argument' do
    expect {
      client.snapshot.create_repository(repository: 'foo')
    }.to raise_exception(ArgumentError)
  end

  it 'requires the :repository argument' do
    expect {
      client.snapshot.create_repository(body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.snapshot.create_repository(repository: 'foo', body: {})).to eq({})
  end
end
