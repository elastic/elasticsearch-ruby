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
# TODO: These tests won't be necessary once we migrate to the new YAML tests
require_relative './spec_helper'

describe 'Capabilities' do
  it 'performs the request' do
    response = CLIENT.capabilities(method: 'GET', path: '/_capabilities', parameters: 'unknown')
    expect(response.status).to eq 200
    expect(response['cluster_name']).not_to be_nil
  end
end
