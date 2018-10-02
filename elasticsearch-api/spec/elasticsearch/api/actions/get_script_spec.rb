require 'spec_helper'

describe 'client#get_script' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil
    ]
  end

  let(:params) do
    { }
  end

  context 'when the `lang` parameter is specificed' do

    let(:url) do
      '_scripts/groovy/foo'
    end

    it 'performs the request' do
      expect(client_double.get_script(lang: 'groovy', id: 'foo')).to eq({})
    end
  end

  context 'when the `lang` parameter is not specificed' do

    let(:url) do
      '_scripts/foo'
    end

    it 'performs the request' do
      expect(client_double.get_script(id: 'foo')).to eq({})
    end
  end
end
