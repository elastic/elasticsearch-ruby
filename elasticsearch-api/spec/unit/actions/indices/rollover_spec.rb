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

describe 'client.indices#rollover' do
  let(:expected_args) do
    [
        'POST',
        url,
        params,
        body,
        {},
        { defined_params: { alias: 'foo' }, endpoint: 'indices.rollover' }
    ]
  end

  let(:url) do
    'foo/_rollover'
  end

  let(:body) do
    nil
  end

  let(:params) do
    {}
  end

  it 'performs the request' do
    expect(client_double.indices.rollover(alias: 'foo')).to be_a Elasticsearch::API::Response
  end

  context 'when an index is specified' do

    let(:url) do
      'foo/_rollover/bar'
    end

    let(:expected_args) do
      [
        'POST',
        url,
        params,
        body,
        {},
        { defined_params: { alias: 'foo', new_index: 'bar' }, endpoint: 'indices.rollover' }
      ]
    end

    it 'performs the request' do
      expect(client_double.indices.rollover(alias: 'foo', new_index: 'bar')).to be_a Elasticsearch::API::Response
    end
  end
end
