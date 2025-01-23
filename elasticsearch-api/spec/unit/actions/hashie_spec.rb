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
require 'hashie'

describe 'Hashie' do

  let(:json) do
    <<-JSON
            {
              "took": 14,
              "timed_out": false,
              "_shards": {
                "total": 1,
                "successful": 1,
                "failed": 0
              },
              "hits": {
                "total": 5,
                "max_score": 0.51104903,
                "hits": [
                  {
                    "_index": "myindex",
                    "_type": "mytype",
                    "_id": "1",
                    "_score": 0.51104903,
                    "_source": {
                      "title": "Test 1",
                      "tags": [
                        "y",
                        "z"
                      ],
                      "published": true,
                      "published_at": "2013-06-22T21:13:00Z",
                      "counter": 1
                    }
                  }
                ]
              },
              "facets": {
                "tags": {
                  "_type": "terms",
                  "missing": 0,
                  "total": 10,
                  "other": 0,
                  "terms": [
                    {
                      "term": "z",
                      "count": 4
                    },
                    {
                      "term": "y",
                      "count": 3
                    },
                    {
                      "term": "x",
                      "count": 3
                    }
                  ]
                }
              }
            }
    JSON
  end

  let(:response) do
    Hashie::Mash.new MultiJson.load(json)
  end

  it 'wraps the response' do
    expect(response.hits.hits.first._source.title).to eq('Test 1')
    expect(response.facets.tags.terms.first.term).to eq('z')
  end
end
