require 'spec_helper'

describe 'client#get_template' do

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

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  context 'when the `lang` parameter is specificed' do

    let(:url) do
      '_search/template/foo'
    end

    it 'performs the request' do
      expect(client_double.get_template(id: 'foo')).to eq({})
    end
  end

  context 'when the request raises a NotFound exception' do

    before do
      expect(client).to receive(:perform_request).and_raise(NotFound)
    end

    it 'raises the exception' do
      expect {
        client.get_template(id: 'foo')
      }.to raise_exception(NotFound)
    end

    context 'when the ignore parameter is specified' do

      it 'returns false' do
        expect(client.get_template(id: 'foo', ignore: 404)).to eq(false)
      end
    end
  end
end
