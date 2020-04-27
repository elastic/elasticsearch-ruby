# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client.snapshot#delete_repository' do

  let(:expected_args) do
    [
        'DELETE',
        url,
        {},
        nil,
        nil
    ]
  end

  let(:url) do
    '_snapshot/foo'
  end

  it 'performs the request' do
    expect(client_double.snapshot.delete_repository(repository: 'foo')).to eq({})
  end

  context 'when multiple indices are specified' do

    let(:url) do
      '_snapshot/foo,bar'
    end

    it 'performs the request' do
      expect(client_double.snapshot.delete_repository(repository: ['foo','bar'])).to eq({})
    end
  end
end
