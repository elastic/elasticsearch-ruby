require 'spec_helper'

describe 'client#scroll' do

  let(:expected_args) do
    [
        'GET',
        '_search/scroll',
        { scroll_id: 'cXVlcn...' },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.scroll(scroll_id: 'cXVlcn...')).to eq({})
  end
end
