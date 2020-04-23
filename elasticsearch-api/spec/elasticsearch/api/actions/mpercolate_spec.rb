# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'client#mpercolate' do

  let(:expected_args) do
    [
        'GET',
        '_mpercolate',
        params,
        body
    ]
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  context 'when a body is provided as a document' do

    let(:body) do
      "{\"percolate\":{\"index\":\"my-index\",\"type\":\"my-type\"}}\n{\"doc\":{\"message\":\"foo bar\"}}\n" +
          "{\"percolate\":{\"index\":\"my-other-index\",\"type\":\"my-other-type\",\"id\":\"1\"}}\n{}\n"
    end

    it 'performs the request' do
      expect(client_double.mpercolate(body: [
          { percolate: { index: "my-index", type: "my-type" } },
          { doc: { message: "foo bar" } },
          { percolate: { index: "my-other-index", type: "my-other-type", id: "1" } },
          { }
      ])).to eq({})
    end
  end

  context 'when a body is provided as a string' do

    let(:body) do
      %Q|{"foo":"bar"}\n{"moo":"lam"}|
    end

    it 'performs the request' do
      expect(client_double.mpercolate(body: %Q|{"foo":"bar"}\n{"moo":"lam"}|)).to eq({})
    end
  end
end
