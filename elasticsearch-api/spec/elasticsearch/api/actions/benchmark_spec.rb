require 'spec_helper'

describe 'client#benchmark' do

  let(:expected_args) do
    [
      'PUT',
      '_bench',
      {},
      { name: 'foo' }
    ]
  end

  it 'performs the request' do
    expect(client_double.benchmark(body: { name: 'foo' }))
  end
end
