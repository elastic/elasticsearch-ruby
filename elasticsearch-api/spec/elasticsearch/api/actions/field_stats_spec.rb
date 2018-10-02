require 'spec_helper'

describe 'client#field_stats' do

  let(:expected_args) do
    [
        'GET',
        '_field_stats',
        { },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.field_stats).to eq({})
  end
end
