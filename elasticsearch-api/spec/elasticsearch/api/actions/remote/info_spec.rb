# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.remote#info' do

  let(:expected_args) do
    [
        'GET',
        '_remote/info',
        {},
        nil,
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.remote.info).to eq({})
  end
end
