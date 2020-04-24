# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

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

 describe 'client#set_upgrade_mode' do

   let(:expected_args) do
    [
       'POST',
       '_ml/set_upgrade_mode',
       {},
       nil,
       nil
    ]
  end

   it 'performs the request' do
    expect(client_double.ml.set_upgrade_mode).to eq({})
  end

   context 'when params are specified' do

     let(:expected_args) do
      [
        'POST',
        '_ml/set_upgrade_mode',
        { enabled: true, timeout: '10m' },
        nil,
        nil
      ]
    end

     it 'performs the request' do
      expect(client_double.ml.set_upgrade_mode(enabled: true, timeout: '10m')).to eq({})
    end
  end
end
