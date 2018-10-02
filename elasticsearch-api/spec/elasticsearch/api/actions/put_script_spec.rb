require 'spec_helper'

describe 'client#put_script' do

  let(:expected_args) do
    [
        'PUT',
        url,
        { },
        { script: 'bar' }
    ]
  end

  let(:url) do
    '_scripts/groovy/foo'
  end

  it 'performs the request' do
    expect(client_double.put_script(lang: 'groovy', id: 'foo', body: { script: 'bar' })).to eq({})
  end

  context 'when the lang parameter is not provided' do

    let(:url) do
      '_scripts/foo'
    end

    it 'performs the request' do
      expect(client_double.put_script(id: 'foo', body: { script: 'bar' })).to eq({})
    end
  end
end
