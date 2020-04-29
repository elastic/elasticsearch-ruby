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

describe 'client#put_script' do
  let(:url) do
    '_scripts/foo'
  end

  context 'when the lang parameter is provided' do
    let(:expected_args) do
      [
        'PUT',
        url,
        {},
        { script: 'bar', lang: 'groovy' },
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.put_script(id: 'foo', body: { script: 'bar', lang: 'groovy' })).to eq({})
    end
  end

  context 'when the lang parameter is not provided' do
    let(:expected_args) do
      [
        'PUT',
        url,
        {},
        { script: 'bar' },
        {}
      ]
    end

    it 'performs the request' do
      expect(client_double.put_script(id: 'foo', body: { script: 'bar' })).to eq({})
    end
  end
end
