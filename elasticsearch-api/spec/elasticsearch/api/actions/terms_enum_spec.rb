# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require 'spec_helper'

describe 'client#terms_enum' do
  let(:expected_args) do
    [
      method,
      'foo/_terms_enum',
      {},
      body,
      {},
      { defined_params: { index: 'foo' }, endpoint: 'terms_enum' }
    ]
  end

  context 'without a body' do
    let(:method) { 'GET' }
    let(:body) { nil }

    it 'performs a GET request' do
      expect(client_double.terms_enum(index: 'foo')).to be_a Elasticsearch::API::Response
    end
  end

  context 'with a body' do
    let(:method) { 'POST' }
    let(:body) { {} }

    it 'performs a POST request' do
      expect(client_double.terms_enum(index: 'foo', body: body)).to be_a Elasticsearch::API::Response
    end
  end

  it 'requires the :index argument' do
    expect { client.terms_enum }.to raise_exception(ArgumentError)
  end
end
