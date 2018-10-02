require 'spec_helper'

describe 'client#reindex' do

  let(:expected_args) do
    [
        'POST',
        '_reindex',
        { },
        { }
    ]
  end

  it 'performs the request' do
    expect(client_double.reindex(body: {})).to eq({})
  end
end
