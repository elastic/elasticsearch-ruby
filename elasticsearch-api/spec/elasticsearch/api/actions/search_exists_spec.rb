require 'spec_helper'

describe 'client#search_exists' do

  let(:expected_args) do
    [
        'POST',
        '_search/exists',
        { q: 'foo' },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.search_exists(q: 'foo')).to eq({})
  end
end
