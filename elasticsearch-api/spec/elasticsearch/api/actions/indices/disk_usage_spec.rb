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

describe 'client.indices#disk_usage' do
  let(:expected_args) do
    [
      'POST',
      "#{index}/_disk_usage",
      {},
      nil,
      {},
      { defined_params: { index: 'foo' }, endpoint: 'indices.disk_usage' }
    ]
  end

  let(:index) { 'foo' }

  it 'performs the request' do
    expect(client_double.indices.disk_usage(index: index)).to be_a Elasticsearch::API::Response
  end

  context 'when there is no index specified' do
    let(:client) do
      Class.new { include Elasticsearch::API }.new
    end

    it 'raises an exception' do
      expect do
        client.indices.disk_usage
      end.to raise_exception(ArgumentError)
    end
  end
end
