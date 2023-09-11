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

describe 'Spatial API' do
  context 'script doc values tests' do
    index = 'geospatial_test'
    before(:all) do
      ADMIN_CLIENT.indices.create(
        index: index,
        body: {
          settings: { number_of_shards: 1},
          mappings: { properties: { geo_shape: { type: 'geo_shape' } } }
        }
      )
      ADMIN_CLIENT.index(
        index: index,
        id: '1',
        body: {
          geo_shape: 'POLYGON((24.04725 59.942,24.04825 59.94125,24.04875 59.94125,24.04875 59.94175,24.048 59.9425,24.0475 59.94275,24.0465 59.94225,24.046 59.94225,24.04575 59.9425,24.04525 59.94225,24.04725 59.942))'
        },
        refresh: true
      )
      ADMIN_CLIENT.indices.refresh
    end

    after(:all) do
      ADMIN_CLIENT.indices.delete(index: index)
    end

    it 'centroid' do
      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: { centroid: { script: { source: "doc['geo_shape'].getCentroid()" } } }
        }
      )
      expect(response['hits']['hits'].first['fields']['centroid'].first['lat']).to eq 59.942043484188616
      expect(response['hits']['hits'].first['fields']['centroid'].first['lon']).to eq 24.047588920220733
    end

    it 'bounding box' do
      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: { bbox: { script: { source: "doc['geo_shape'].getBoundingBox()" } } }
        }
      )
      expect(response['hits']['hits'].first['fields']['bbox'].first['top_left']['lat']).to eq 59.942749994806945
      expect(response['hits']['hits'].first['fields']['bbox'].first['top_left']['lon']).to eq 24.045249950140715
      expect(response['hits']['hits'].first['fields']['bbox'].first['bottom_right']['lat']).to eq 59.94124996941537
      expect(response['hits']['hits'].first['fields']['bbox'].first['bottom_right']['lon']).to eq 24.048749981448054
    end

    it 'label position' do
      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: { label_position: { script: { source: "doc['geo_shape'].getLabelPosition()" } } }
        }
      )
      expect(response['hits']['hits'].first['fields']['label_position'].first['lat']).to eq 59.942043484188616
      expect(response['hits']['hits'].first['fields']['label_position'].first['lon']).to eq 24.047588920220733
    end

    it 'bounding box points' do
      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: {
            topLeft: { script: { source: "doc['geo_shape'].getBoundingBox().topLeft()" } },
            bottomRight: { script: { source: "doc['geo_shape'].getBoundingBox().bottomRight()" } }
          }
        }
      )
      expect(response['hits']['hits'].first['fields']['topLeft'].first['lat']).to eq 59.942749994806945
      expect(response['hits']['hits'].first['fields']['topLeft'].first['lon']).to eq 24.045249950140715
      expect(response['hits']['hits'].first['fields']['bottomRight'].first['lat']).to eq 59.94124996941537
      expect(response['hits']['hits'].first['fields']['bottomRight'].first['lon']).to eq 24.048749981448054
    end

    it 'dimensional type' do
      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: { type: { script: { source:  "doc['geo_shape'].getDimensionalType()" } } }
        }
      )
      expect(response['hits']['hits'].first['fields']['type'].first).to eq 2
    end

    it 'geoshape value' do
      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: { type: { script: { source:  "doc['geo_shape'].get(0)" } } }
        }
      )
      expect(response['hits']['hits'].first['fields']['type'].first).to eq '<unserializable>'

      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: { type: { script: { source:  "field('geo_shape').get(null)"} } }
        }
      )
      expect(response['hits']['hits'].first['fields']['type'].first).to eq '<unserializable>'

      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: { type: { script: { source:  "$('geo_shape', null)"} } }
        }
      )
      expect(response['hits']['hits'].first['fields']['type'].first).to eq '<unserializable>'
    end

    it 'diagonal length' do
      response = ADMIN_CLIENT.search(
        rest_total_hits_as_int: true,
        body: {
          script_fields: {
            width: { script: { source: "doc['geo_shape'].getMercatorWidth()" } },
            height: { script: { source: "doc['geo_shape'].getMercatorHeight()" } }
          }
        }
      )
      expect(response['hits']['hits'].first['fields']['width'].first).to eq 389.62170283915475
      expect(response['hits']['hits'].first['fields']['height'].first).to eq 333.37976841442287
    end
  end
end
