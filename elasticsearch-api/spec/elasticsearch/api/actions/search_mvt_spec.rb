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

describe 'client#search_mvt' do
  let(:expected_args) do
    [
      method,
      url,
      params,
      body,
      {},
      { defined_params: { field: 'field', index: 'foo', x: 57.2127, y: 6.2348, zoom: 10 },
        endpoint: 'search_mvt' }
    ]
  end

  context 'with right parameters' do
    let(:method) { 'POST' }
    let(:url) { 'foo/_mvt/field/10/57.2127/6.2348' }
    let(:params) { {} }
    let(:body) { nil }

    it 'performs the request' do
      expect(client_double.search_mvt(index: 'foo', field: 'field', zoom: 10, x: 57.2127, y: 6.2348)).to be_a Elasticsearch::API::Response
    end
  end

  context 'when a param is missing' do
    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an ArgumentError' do
      expect{
        client.search_mvt
      }.to raise_exception(ArgumentError)
    end
  end
end
