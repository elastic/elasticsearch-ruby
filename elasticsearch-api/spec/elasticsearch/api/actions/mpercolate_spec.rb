# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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
