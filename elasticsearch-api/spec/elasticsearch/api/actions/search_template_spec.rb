require 'spec_helper'

describe 'client#search_template' do

  let(:expected_args) do
    [
        'GET',
        'foo/_search/template',
        { },
        { foo: 'bar' }
    ]
  end

  it 'performs the request' do
    expect(client_double.search_template(index: 'foo', body: { foo: 'bar' })).to eq({})
  end
end
