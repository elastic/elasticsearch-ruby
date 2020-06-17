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

describe 'JSON builders' do
  context 'JBuilder' do
    let(:expected_args) do
      [
        'POST',
        '_search',
        {},
        body,
        {}
      ]
    end

    let(:json) do
      Jbuilder.encode do |json|
        json.query do
          json.match do
            json.title do
              json.query 'test'
            end
          end
        end
      end
    end

    let(:body) do
      json
    end

    it 'properly builds the json' do
      expect(client_double.search(body: json)).to eq({})
    end
  end

  context 'Jsonify' do
    let(:expected_args) do
      [
        'POST',
        '_search',
        {},
        body,
        {}
      ]
    end

    let(:json) do
      Jsonify::Builder.compile do |json|
        json.query do
          json.match do
            json.title do
              json.query 'test'
            end
          end
        end
      end
    end

    let(:body) do
      json
    end

    it 'properly builds the json' do
      expect(client_double.search(body: json)).to eq({})
    end
  end
end
