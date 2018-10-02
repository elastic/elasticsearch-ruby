require 'spec_helper'

describe 'client#render_search_template' do

  let(:expected_args) do
    [
        'GET',
        '_render/template',
        { id: 'foo' },
        { foo: 'bar' }
    ]
  end

  it 'performs the request' do
    expect(client_double.render_search_template(id: 'foo', body: { foo: 'bar' })).to eq({})
  end
end
