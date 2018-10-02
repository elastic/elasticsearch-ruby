require 'spec_helper'

describe 'client#field_caps' do

  let(:expected_args) do
    [
        'GET',
        'foo/_field_caps',
        { fields: 'bar' },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.field_caps(index: 'foo', fields: 'bar')).to eq({})
  end
end
