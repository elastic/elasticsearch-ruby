# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#update_by_query' do

  let(:expected_args) do
    [
        'POST',
        'foo/_update_by_query',
        {},
        nil,
        {}
    ]
  end

  it 'performs the request' do
    expect(client_double.update_by_query(index: 'foo')).to eq({})
  end
end
