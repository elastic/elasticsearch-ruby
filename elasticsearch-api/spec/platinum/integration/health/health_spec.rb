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

require_relative '../platinum_helper'

describe 'Health API' do
  context 'Usage stats on the health API' do
    before do
      ADMIN_CLIENT.indices.create(
        index: 'red_index',
        body: {
          settings: {
            number_of_shards: 1,
            number_of_replicas: 0,
            'index.routing.allocation.enable' => 'none'
          }
        }
      )
    end

    after do
      ADMIN_CLIENT.indices.delete(index: 'red_index')
    end

    it 'responds with health report' do
      expect(ADMIN_CLIENT.health_report.status).to eq 200
      expect(ADMIN_CLIENT.health_report(feature: 'disk').status).to eq 200
      response = ADMIN_CLIENT.xpack.usage
      expect(response['health_api']['available']).to eq true
      expect(response['health_api']['enabled']).to eq true
      expect(response['health_api']['invocations']['total']).to be >= 2
      expect(response['health_api']['invocations']['verbose_true']).to be >= 2
    end
  end
end
