require 'spec_helper'

describe 'client#abort_benchmark' do

  let(:expected_args) do
    [
      'POST',
      '_bench/abort/foo',
      {},
      nil
    ]
  end

  it 'performs the request' do
    expect(client_double.abort_benchmark(name: 'foo'))
  end
end
