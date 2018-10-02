require 'spec_helper'

describe 'client#count_percolate' do

  let(:expected_args) do
    [
      'GET',
      'foo/bar/_percolate/count',
      {},
      { doc: { foo: 'bar' } }
    ]
  end

  it 'performs the request' do
    expect(client_double.count_percolate(index: 'foo', type: 'bar', body: { doc: { foo: 'bar' } })).to eq({})
  end
end
