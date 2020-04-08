# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#security#create_api_key' do

  let(:expected_args) do
    [
        'PUT',
        '_security/api_key',
        {},
        body,
        {}
    ]
  end

  let(:body) do
    {
        "name": "my-api-key",
        "expiration": "1d",
        "role_descriptors": {
            "role-a": {
                "cluster": ["all"],
                "index": [
                    {
                        "names": ["index-a"],
                        "privileges": ["read"]
                    }
                ]
            },
            "role-b": {
                "cluster": ["manage"],
                "index": [
                    {
                        "names": ["index-b"],
                        "privileges": ["all"]
                    }
                ]
            }
        }
    }
  end

  it 'performs the request' do
    expect(client_double.security.create_api_key(body: body)).to eq({})
  end

  context 'when params are specified' do

    let(:expected_args) do
      [
          'PUT',
          '_security/api_key',
          { refresh: 'wait_for' },
          body,
          {}
      ]
    end

    it 'performs the request' do
      expect(client_double.security.create_api_key(body: body, refresh: 'wait_for')).to eq({})
    end
  end
end
