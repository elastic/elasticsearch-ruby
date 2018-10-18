require 'spec_helper'

describe 'client.cat#fielddata' do

  let(:expected_args) do
    [
        'GET',
        '_cat/fielddata',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.cat.fielddata).to eq({})
  end

  context 'when field are specified' do

    let(:expected_args) do
      [
          'GET',
          '_cat/fielddata/foo,bar',
          {},
          nil,
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.cat.fielddata(fields: ['foo', 'bar'])).to eq({})
    end
  end
end
