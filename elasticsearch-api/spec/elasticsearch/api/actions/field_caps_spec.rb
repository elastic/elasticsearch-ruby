# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#field_caps' do

  let(:expected_args) do
    [
        'GET',
        'foo/_field_caps',
        { fields: 'bar' },
        nil
    ]
  end

  it 'performs the request' do
    expect(client_double.field_caps(index: 'foo', fields: 'bar')).to eq({})
  end
end
