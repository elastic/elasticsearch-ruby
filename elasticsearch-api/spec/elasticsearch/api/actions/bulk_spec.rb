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

describe 'client#bulk' do

  let(:expected_args) do
    [
        'POST',
        url,
        params,
        body,
        headers
    ]
  end

  let(:headers) { { 'Content-Type' => 'application/x-ndjson' } }
  let(:params) { {} }
  let(:url) { '_bulk' }
  let(:body) { '' }

  context 'when a list of operations is provided' do

    let(:body) do
      <<-PAYLOAD.gsub(/^\s+/, '')
        {"index":{"_index":"myindexA","_type":"mytype","_id":"1"}}
        {"title":"Test"}
        {"update":{"_index":"myindexB","_type":"mytype","_id":"2"}}
        {"doc":{"title":"Update"}}
        {"delete":{"_index":"myindexC","_type":"mytypeC","_id":"3"}}
        {"index":{"_index":"myindexD","_type":"mytype","_id":"1"}}
        {"data":"MYDATA"}
      PAYLOAD
    end

    it 'performs the request' do
      expect(client_double.bulk(:body => [
          { :index =>  { :_index => 'myindexA', :_type => 'mytype', :_id => '1', :data => { :title => 'Test' } } },
          { :update => { :_index => 'myindexB', :_type => 'mytype', :_id => '2', :data => { :doc => { :title => 'Update' } } } },
          { :delete => { :_index => 'myindexC', :_type => 'mytypeC', :_id => '3' } },
          { :index =>  { :_index => 'myindexD', :_type => 'mytype', :_id => '1', :data => { :data => 'MYDATA' } } },
      ])).to eq({})
    end
  end

  context 'when an index is specified' do

    let(:url) { 'myindex/_bulk' }

    it 'performs the request' do
      expect(client_double.bulk(index: 'myindex', body: [])).to eq({})
    end
  end

  context 'when there are data keys in the head/data payloads' do

    let(:body) do
      <<-PAYLOAD.gsub(/^\s+/, '')
        {"update":{"_index":"myindex","_type":"mytype","_id":"1"}}
        {"doc":{"data":{"title":"Update"}}}
      PAYLOAD
    end

    it 'performs the request' do
      expect(client_double.bulk(body:[ { :update => { :_index => 'myindex', :_type => 'mytype', :_id => '1' } },
                                       { :doc => { :data => { :title => 'Update' } } } ])).to eq({})
    end
  end

  context 'when the payload is a string' do

    let(:body) do
      'foo\nbar'
    end

    it 'performs the request' do
      expect(client_double.bulk(body: 'foo\nbar')).to eq({})
    end
  end

  context 'when the payload is an array of Strings' do

    let(:body) do
      "foo\nbar\n"
    end

    it 'performs the request' do
      expect(client_double.bulk(body: ['foo', 'bar'])).to eq({})
    end
  end

  context 'when there are parameters' do

    let(:params) do
      { refresh: true }
    end

    it 'performs the request' do
      expect(client_double.bulk(refresh: true, body: [])).to eq({})
    end
  end

  context 'when url characters need to be URL-escaped' do

    let(:url) do
      'foo%5Ebar/_bulk'
    end

    it 'performs the request' do
      expect(client_double.bulk(index: 'foo^bar', body: [])).to eq({})
    end
  end

  context 'when the type is provided' do

    let(:url) do
      'myindex/mytype/_bulk'
    end

    it 'performs the request' do
      expect(client_double.bulk(index: 'myindex', type: 'mytype', body: [])).to eq({})
    end
  end
end
