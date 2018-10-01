require 'spec_helper'

describe 'client#delete_script' do

  let(:expected_args) do
    [
        'DELETE',
        '_scripts/groovy/foo',
        {},
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.delete_script(lang: 'groovy', id: 'foo')).to eq({})
  end

  context 'when lang parameter is not provided' do

    let(:expected_args) do
      [
          'DELETE',
          '_scripts/foo',
          {},
          nil
      ]
    end

    it 'performs the request' do
      expect(client_double.delete_script(id: 'foo')).to eq({})
    end
  end
end
