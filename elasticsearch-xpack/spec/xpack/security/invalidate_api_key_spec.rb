# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#security#create_api_key' do

  let(:expected_args) do
    [
        'DELETE',
        '_security/api_key',
        {},
        body,
        nil
    ]
  end

  let(:body) do
    { id: 1 }
  end

  it 'performs the request' do
    expect(client_double.security.invalidate_api_key(body: body)).to eq({})
  end
end
