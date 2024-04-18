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
require_relative 'helpers_spec_helper'
require 'elasticsearch/helpers/bulk_helper'
require 'tempfile'

context 'Elasticsearch client helpers' do
  context 'Bulk helper' do
    let(:index) { 'bulk_animals' }
    let(:index_slice) { 'bulk_animals_slice' }
    let(:params) { { refresh: 'wait_for' } }
    let(:bulk_helper) { Elasticsearch::Helpers::BulkHelper.new(client, index, params) }
    let(:docs) do
      [
        { scientific_name: 'Lama guanicoe', name:'Guanaco' },
        { scientific_name: 'Tayassu pecari', name:'White-lipped peccary' },
        { scientific_name: 'Snycerus caffer', name:'Buffalo, african' },
        { scientific_name: 'Coluber constrictor', name:'Snake, racer' },
        { scientific_name: 'Thalasseus maximus', name:'Royal tern' },
        { scientific_name: 'Centrocercus urophasianus', name:'Hen, sage' },
        { scientific_name: 'Sitta canadensis', name:'Nuthatch, red-breasted' },
        { scientific_name: 'Aegypius tracheliotus', name:'Vulture, lappet-faced' },
        { scientific_name: 'Bucephala clangula', name:'Common goldeneye' },
        { scientific_name: 'Felis pardalis', name:'Ocelot' }
      ]
    end

    after do
      client.indices.delete(index: index, ignore: 404)
      client.indices.delete(index: index_slice, ignore: 404)
    end

    it 'Ingests documents' do
      response = bulk_helper.ingest(docs)
      expect(response).to be_an_instance_of Elasticsearch::API::Response
      expect(response.status).to eq(200)
      expect(response['items'].map { |a| a['index']['status'] }.uniq.first).to eq 201
    end

    it 'Updates documents' do
      docs = [
        { scientific_name: 'Otocyon megalotos', name: 'Bat-eared fox' },
        { scientific_name: 'Herpestes javanicus', name: 'Small Indian mongoose' }
      ]
      bulk_helper.ingest(docs)
      # Get the ingested documents, add id and modify them to update them:
      animals = client.search(index: index)['hits']['hits']
      # Add id to each doc
      docs = animals.map { |animal| animal['_source'].merge({'id' => animal['_id'] }) }
      docs.map { |doc| doc['scientific_name'].upcase! }
      response = bulk_helper.update(docs)
      expect(response.status).to eq(200)
      expect(response['items'].map { |i| i['update']['result'] }.uniq.first).to eq('updated')
    end

    it 'Deletes documents' do
      response = bulk_helper.ingest(docs)
      ids = response.body['items'].map { |a| a['index']['_id'] }
      response = bulk_helper.delete(ids)
      expect(response.status).to eq 200
      expect(response['items'].map { |item| item['delete']['result'] }.uniq.first).to eq('deleted')
      expect(client.count(index: index)['count']).to eq(0)
    end

    it 'Ingests documents and yields response and docs' do
      slice = 2
      bulk_helper = Elasticsearch::Helpers::BulkHelper.new(client, index_slice, params)
      response = bulk_helper.ingest(docs, {slice: slice}) do |response, docs|
        expect(response).to be_an_instance_of Elasticsearch::API::Response
        expect(docs.count).to eq slice
      end
      response = client.search(index: index_slice, size: 200)
      expect(response['hits']['hits'].map { |a| a['_source'].transform_keys(&:to_sym) }).to eq docs
    end

    context 'JSON File helper' do
      let(:file) { Tempfile.new('test-data.json') }
      let(:json) do
        json = <<~JSON
        [
          {
            "character_name": "Anallese Lonie",
           "species": "mouse",
           "catchphrase": "Seamless regional definition",
           "favorite_food": "pizza"
          },
          {
            "character_name": "Janey Davidovsky",
           "species": "cat",
           "catchphrase": "Down-sized responsive pricing structure",
           "favorite_food": "pizza"
          },
          {
            "character_name": "Morse Mountford",
           "species": "cat",
           "catchphrase": "Ameliorated modular data-warehouse",
           "favorite_food": "carrots"
          },
          {
            "character_name": "Saundra Kauble",
           "species": "dog",
           "catchphrase": "Synchronised 24/7 support",
           "favorite_food": "carrots"
          },
          {
            "character_name": "Kain Viggars",
           "species": "cat",
           "catchphrase": "Open-architected asymmetric circuit",
           "favorite_food": "carrots"
          }
        ]
        JSON
      end

      before do
        file.write(json)
        file.rewind
      end

      after do
        file.close
        file.unlink
      end

      it 'Ingests a JSON file' do
        response = bulk_helper.ingest_json(file)

        expect(response).to be_an_instance_of Elasticsearch::API::Response
        expect(response.status).to eq(200)
      end

      context 'with data not in root of JSON file' do
        let(:json) do
          json = <<~JSON
          {
            "field": "value",
            "status": 200,
            "data": {
              "items": [
                {
                  "character_name": "Anallese Lonie",
                  "species": "mouse",
                  "catchphrase": "Seamless regional definition",
                  "favorite_food": "pizza"
                },
                {
                  "character_name": "Janey Davidovsky",
                  "species": "cat",
                  "catchphrase": "Down-sized responsive pricing structure",
                  "favorite_food": "pizza"
                },
                {
                  "character_name": "Morse Mountford",
                  "species": "cat",
                  "catchphrase": "Ameliorated modular data-warehouse",
                  "favorite_food": "carrots"
                },
                {
                  "character_name": "Saundra Kauble",
                  "species": "dog",
                  "catchphrase": "Synchronised 24/7 support",
                  "favorite_food": "carrots"
                },
                {
                  "character_name": "Kain Viggars",
                  "species": "cat",
                  "catchphrase": "Open-architected asymmetric circuit",
                  "favorite_food": "carrots"
                }
              ]
            }
          }
          JSON
        end

        it 'Ingests a JSON file passing keys as Array' do
          response = bulk_helper.ingest_json(file, { keys: ['data', 'items'] })
          expect(response).to be_an_instance_of Elasticsearch::API::Response
          expect(response.status).to eq(200)
          expect(response['items'].map { |a| a['index']['status'] }.uniq.first).to eq 201
        end

        it 'Ingests a JSON file passing keys as String' do
          response = bulk_helper.ingest_json(file, { keys: 'data,items' })
          expect(response).to be_an_instance_of Elasticsearch::API::Response
          expect(response.status).to eq(200)
          expect(response['items'].map { |a| a['index']['status'] }.uniq.first).to eq 201
        end
      end
    end
  end
end
