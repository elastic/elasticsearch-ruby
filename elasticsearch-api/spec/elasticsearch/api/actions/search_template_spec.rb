# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#search_template' do

  let(:expected_args) do
    [
        'GET',
        'foo/_search/template',
        { },
        { foo: 'bar' }
    ]
  end

  it 'performs the request' do
    expect(client_double.search_template(index: 'foo', body: { foo: 'bar' })).to eq({})
  end
end
