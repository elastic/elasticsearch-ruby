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

describe 'client#ml.put_trained_model_definition_part' do
  let(:expected_args) do
    [
      'PUT',
      '_ml/trained_models/foo/definition/3',
      {},
      {},
      {},
      { defined_params: { model_id: 'foo', part: 3 },
       endpoint: 'ml.put_trained_model_definition_part' }
    ]
  end

  it 'performs the request' do
    expect(client_double.ml.put_trained_model_definition_part(model_id: 'foo', body: {}, part: 3)).to be_a Elasticsearch::API::Response
  end

  let(:client) do
    Class.new { include Elasticsearch::API }.new
  end

  context 'when a model_id is not provided' do
    it 'raises an exception' do
      expect {
        client.ml.put_trained_model_definition_part(body: {}, part: 3)
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when a body is not provided' do
    it 'raises an exception' do
      expect {
        client.ml.put_trained_model_definition_part(model_id: 'foo', part: 3)
      }.to raise_exception(ArgumentError)
    end
  end

  context 'when a part is not provided' do
    it 'raises an exception' do
      expect {
        client.ml.put_trained_model_definition_part(model_id: 'foo', body: {})
      }.to raise_exception(ArgumentError)
    end
  end
end
