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

describe 'client#async_search.status' do
  let(:expected_args) do
    [
      'GET',
      '_async_search/status/foo',
      {},
      nil,
      {},
      { defined_params: { id: 'foo' }, endpoint: 'async_search.status' }
    ]
  end

  it 'performs the request' do
    expect(client_double.async_search.status(id: 'foo')).to be_a Elasticsearch::API::Response
  end
end
