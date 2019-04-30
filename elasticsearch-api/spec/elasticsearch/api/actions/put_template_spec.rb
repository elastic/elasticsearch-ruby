require 'spec_helper'

describe 'client#put_template' do

  let(:expected_args) do
    [
        'POST',
        '_scripts/foo',
        { },
        { }
    ]
  end

  it 'performs the request' do
    expect(client_double.put_template(id: 'foo', body: { })).to eq({})
  end
end
