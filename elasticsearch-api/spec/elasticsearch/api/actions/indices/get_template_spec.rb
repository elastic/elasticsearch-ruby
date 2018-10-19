require 'spec_helper'

describe 'client.indices#get_template' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil,
        nil
    ]
  end

  let(:params) do
    {}
  end

  let(:url) do
    '_template/foo'
  end

  it 'performs the request' do
    expect(client_double.indices.get_template(name: 'foo')).to eq({})
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      '_template/foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.indices.get_template(name: 'foo^bar')).to eq({})
    end
  end
end
