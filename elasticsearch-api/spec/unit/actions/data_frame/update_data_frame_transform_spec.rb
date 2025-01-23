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

describe 'client#update_transform' do

  let(:expected_args) do
    [
      'POST',
      '_transform/foo/_update',
      params,
      {},
      {},
      { defined_params: { transform_id: 'foo'}, endpoint: 'transform.update_transform' }
    ]
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(
      client_double.transform
        .update_transform(transform_id: 'foo', body: {})
    ).to be_a Elasticsearch::API::Response
  end

  context 'when body is not provided' do
    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.transform.update_transform(transform_id: 'foo')
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when a transform_id is not provided' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect {
        client.transform.update_transform(body: {})
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when params are specified' do

    let(:params) do
      { defer_validation: true }
    end

    it 'performs the request' do
      expect(
        client_double.transform
          .update_transform(transform_id: 'foo', body: {}, defer_validation: true)
      ).to be_a Elasticsearch::API::Response
    end
  end
end
