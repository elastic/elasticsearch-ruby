# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#abort_benchmark' do

  let(:expected_args) do
    [
      'POST',
      '_bench/abort/foo',
      {},
      nil
    ]
  end

  it 'performs the request' do
    expect(client_double.abort_benchmark(name: 'foo'))
  end
end
