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

describe 'client.ingest#put_ip_location_database' do
  let(:expected_args) do
    [
      'PUT',
      '_ingest/ip_location/database/foo',
      {},
      {},
      {},
      { defined_params: { id: 'foo' }, endpoint: 'ingest.put_ip_location_database' }
    ]
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  it 'requires the :id argument' do
    expect {
      client.ingest.put_ip_location_database
    }.to raise_exception(ArgumentError)
  end

  it 'performs the request' do
    expect(client_double.ingest.put_ip_location_database(id: 'foo', body: {})).to be_a Elasticsearch::API::Response
  end
end
