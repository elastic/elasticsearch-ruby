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

describe 'client.indices#get_template' do

  let(:expected_args) do
    [
        'GET',
        url,
        params,
        nil,
        nil
    ]
  end

  let(:params) do
    {}
  end

  let(:url) do
    '_template/foo'
  end

  it 'performs the request' do
    expect(client_double.indices.get_template(name: 'foo')).to eq({})
  end

  context 'when the path needs to be URL-escaped' do

    let(:url) do
      '_template/foo%5Ebar'
    end

    it 'performs the request' do
      expect(client_double.indices.get_template(name: 'foo^bar')).to eq({})
    end
  end

  context 'when a \'not found\' exception is raised with the ignore parameter' do

    let(:client) do
      Class.new { include Elasticsearch::API }.new.tap do |_client|
        expect(_client).to receive(:perform_request).with(*expected_args).and_raise(NotFound)
      end
    end

    let(:url) do
      '_template'
    end

    let(:params) do
      { ignore: 404 }
    end

    it 'returns false' do
      skip
      expect(client.indices.get_template(id: 'foo', ignore: 404)).to eq(false)
    end
  end
end
