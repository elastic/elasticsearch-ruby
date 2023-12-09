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
require 'ostruct'

describe Elasticsearch::Client do
  let(:transport) { client.instance_variable_get('@transport') }
  let(:client) { described_class.new.tap { |cl| cl.instance_variable_set('@verified', true) } }

  before do
    allow(transport).to receive(:perform_request) { OpenStruct.new(body: '') }
  end

  context 'when x-opaque-id is set' do
    it 'uses x-opaque-id on a request' do
      client.search(opaque_id: '12345')
      expect(transport).to have_received(:perform_request)
        .with('GET', '_search', {}, nil, { 'X-Opaque-Id' => '12345' }, {:endpoint=>"search"})
    end
  end

  context 'when an x-opaque-id prefix is set on initialization' do
    let(:prefix) { 'elastic_cloud' }
    let(:client) do
      described_class.new(opaque_id_prefix: prefix).tap { |cl| cl.instance_variable_set('@verified', true) }
    end

    it 'uses x-opaque-id on a request' do
      expect { client.search(opaque_id: '12345') }.not_to raise_error
      expect(transport).to have_received(:perform_request)
        .with('GET', '_search', {}, nil, { 'X-Opaque-Id' => 'elastic_cloud12345' }, {:endpoint=>"search"})
    end
  end
end
