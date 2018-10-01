require 'spec_helper'

describe 'client#delete_template' do

  let(:expected_args) do
    [
        'DELETE',
        '_search/template/foo',
        {},
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.delete_template(id: 'foo')).to eq({})
  end
end
