# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'spec_helper'

describe 'JSON builders' do

  context 'JBuilder' do

    let(:expected_args) do
      [
          'GET',
          '_search',
          {},
          body
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
          'GET',
          '_search',
          {},
          body
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
