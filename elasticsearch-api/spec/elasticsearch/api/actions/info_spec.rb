require 'spec_helper'

describe 'client#info' do

  let(:expected_args) do
    [
        'GET',
        '',
        { },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.info).to eq({})
  end
end
