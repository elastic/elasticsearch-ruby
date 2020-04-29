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

describe Elasticsearch::API do

  describe '#settings' do

    it 'allows access to settings' do
      expect(described_class.settings).not_to be_nil
    end

    it 'has a default serializer' do
      expect(Elasticsearch::API.serializer).to eq(MultiJson)
    end

    context 'when settings are changed' do

      before do
        Elasticsearch::API.settings[:foo] = 'bar'
      end

      it 'changes the settings' do
        expect(Elasticsearch::API.settings[:foo]).to eq('bar')
      end
    end
  end
end
