require 'spec_helper'

describe 'client#delete_by_query' do

  let(:expected_args) do
    [
        'POST',
        'foo/_delete_by_query',
        {},
        { term: {} }
    ]
  end

  it 'requires the :index argument' do
    expect {
      Class.new { include Elasticsearch::API }.new.delete_by_query(body: {})
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.delete_by_query(index: 'foo', body: { term: {} })).to eq({})
  end

  context 'when the type argument is provided' do

    let(:expected_args) do
      [
        'POST',
        'foo/tweet,post/_delete_by_query',
        {},
        { term: {} }
      ]
    end

    it 'performs the request' do
      expect(client_double.delete_by_query(index: 'foo', type: ['tweet', 'post'], body: { term: {} })).to eq({})
    end
  end

  context 'when a query is provided' do

    let(:expected_args) do
      [
        'POST',
        'foo/_delete_by_query',
        { q: 'foo:bar' },
        nil
      ]
    end

    it 'performs the request' do
      expect(client_double.delete_by_query(index: 'foo', q: 'foo:bar')).to eq({})
    end
  end
end
