require 'spec_helper'

describe 'client#count' do

  let(:expected_args) do
    [
      'GET',
      '_count',
      {},
      nil
    ]
  end

  it 'performs the request' do
    expect(client_double.count).to eq({})
  end

  context 'when an index and type are specified' do

    let(:expected_args) do
      [
          'GET',
          'foo,bar/t1,t2/_count',
          {},
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.count(index: ['foo','bar'], type: ['t1','t2'])).to eq({})
    end
  end

  context 'when there is a query provided' do

    let(:expected_args) do
      [
          'GET',
          '_count',
          {},
          { match: { foo: 'bar' } }
      ]
    end

    it 'performs the request' do
      expect(client_double.count(body: { match: { foo: 'bar' } })).to eq({})
    end
  end
end
