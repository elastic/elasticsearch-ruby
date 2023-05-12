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
ELASTICSEARCH_URL = ENV['TEST_ES_SERVER'] || "http://localhost:#{(ENV['PORT'] || 9200)}"
raise URI::InvalidURIError unless ELASTICSEARCH_URL =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

require 'spec_helper'
require 'elasticsearch/helpers/bulk_helper'

context 'Elasticsearch client helpers' do
  context 'Bulk helper' do
    let(:client) do
      Elasticsearch::Client.new(
        host: ELASTICSEARCH_URL,
        user: 'elastic',
        password: 'changeme'
      )
    end
    let(:index) { 'bulk_animals' }
    let(:params) { { refresh: 'wait_for' } }
    let(:bulk_helper) { Elasticsearch::Helpers::BulkHelper.new(index: index, client: client, params: params) }
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
    end

    it 'ingests' do
      response = bulk_helper.ingest(docs)
      expect(response.status).to eq(200)
    end

    it 'updates' do
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

    it 'deletes' do
      response = bulk_helper.ingest(docs)
      ids = response.body['items'].map { |a| a['index']['_id'] }
      response = bulk_helper.delete(ids)
      expect(response.status).to eq 200
      expect(response['items'].map { |item| item['delete']['result'] }.uniq.first).to eq('deleted')
      expect(client.count(index: index)['count']).to eq(0)
    end
  end
end
