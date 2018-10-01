require 'spec_helper'

describe 'client#list_benchmarks' do

  let(:expected_args) do
    [
        'GET',
        '_bench',
        { },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.list_benchmarks).to eq({})
  end
end
