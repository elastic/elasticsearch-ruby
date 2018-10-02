require 'spec_helper'

describe 'client#update_by_query' do

  let(:expected_args) do
    [
        'POST',
        'foo/_update_by_query',
        { },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.update_by_query(index: 'foo')).to eq({})
  end
end
