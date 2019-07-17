# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#security#get_api_key' do

  let(:expected_args) do
    [
        'GET',
        '_security/api_key',
        params,
        nil,
        nil
    ]
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.security.get_api_key).to eq({})
  end

  context 'when params are specified' do

    let(:params) do
      { id: '1',
        username: 'user',
        name: 'my-api-key',
        realm_name: '_es_api_key' }
    end

    it 'performs the request' do
      expect(client_double.security.get_api_key(id: '1',
                                                   username: 'user',
                                                   name: 'my-api-key',
                                                   realm_name: '_es_api_key')).to eq({})
    end
  end
end
