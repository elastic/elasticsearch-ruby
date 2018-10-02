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
