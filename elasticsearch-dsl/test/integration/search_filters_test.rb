# encoding: UTF-8

require 'test_helper'

module Elasticsearch
  module Test
    class FiltersIntegrationTest < ::Elasticsearch::Test::IntegrationTestCase
      include Elasticsearch::DSL::Search

      context "Filters integration" do
        startup do
          Elasticsearch::Extensions::Test::Cluster.start(number_of_nodes: 1) if ENV['SERVER'] and not Elasticsearch::Extensions::Test::Cluster.running?(number_of_nodes: 1)
        end

        setup do
          @client.indices.create index: 'test'
          @client.index index: 'test', type: 'd', id: 1,
                        body: { name: 'Original',
                                color: 'red',
                                size: 'xxl',
                                category: 'unisex',
                                manufacturer: 'a' }

          @client.index index: 'test', type: 'd', id: 2,
                        body: { name: 'Original',
                                color: 'red',
                                size: 'xl',
                                category: 'unisex',
                                manufacturer: 'a' }

          @client.index index: 'test', type: 'd', id: 3,
                        body: { name: 'Original',
                                color: 'red',
                                size: 'l',
                                category: 'unisex',
                                manufacturer: 'a' }

          @client.index index: 'test', type: 'd', id: 4,
                        body: { name: 'Western',
                                color: 'red',
                                size: 'm',
                                category: 'men',
                                manufacturer: 'c' }

          @client.index index: 'test', type: 'd', id: 5,
                        body: { name: 'Modern',
                                color: 'grey',
                                size: 'l',
                                category: 'men',
                                manufacturer: 'b' }

          @client.index index: 'test', type: 'd', id: 6,
                        body: { name: 'Modern',
                                color: 'grey',
                                size: 's',
                                category: 'men',
                                manufacturer: 'b' }

          @client.index index: 'test', type: 'd', id: 7,
                        body: { name: 'Modern',
                                color: 'grey',
                                size: 's',
                                category: 'women',
                                manufacturer: 'b' }

          @client.indices.refresh index: 'test'
        end

        context "term filter" do
          should "return matching documents" do
            response = @client.search index: 'test', body: search {
              query do
                bool do
                  filter do
                    term color: 'red'
                  end
                end
              end
            }.to_hash

            assert_equal 4, response['hits']['total']
            assert response['hits']['hits'].all? { |h| h['_source']['color'] == 'red'  }, response.inspect
          end
        end

        context "terms filter" do
          should "return matching documents" do
            response = @client.search index: 'test', body: search {
              query do
                bool do
                  filter do
                    terms color: ['red', 'grey', 'gold']
                  end
                end
              end
            }.to_hash

            assert_equal 7, response['hits']['total']
          end
        end

        context "bool filter" do
          should "return correct documents" do
            response = @client.search index: 'test', body: search {
              query do
                bool do
                  filter do
                    bool do
                      must do
                        term size:  'l'
                      end

                      should do
                        term color: 'red'
                      end

                      should do
                        term category: 'men'
                      end

                      must_not do
                        term manufacturer: 'b'
                      end
                    end
                  end
                end
              end
            }.to_hash

            assert_equal 1,   response['hits']['hits'].size
            assert_equal '3', response['hits']['hits'][0]['_id'].to_s
          end
        end

        context "geographical filters" do
          setup do
            @client.indices.create index: 'places', body: {
              mappings: {
                d: {
                  properties: {
                    location: {
                      type: 'geo_point'
                    }
                  }
                }
              }
            }
            @client.index index: 'places', type: 'd', id: 1,
                          body: { name: 'Vyšehrad',
                                  location: '50.064399, 14.420018'}

            @client.index index: 'places', type: 'd', id: 2,
                          body: { name: 'Karlštejn',
                                  location: '49.939518, 14.188046'}

            @client.indices.refresh index: 'places'
          end

          should "find documents within the bounding box" do
            response = @client.search index: 'places', body: search {
              query do
                bool do
                  filter do
                    geo_bounding_box :location do
                      top_right   "50.1815123678,14.7149200439"
                      bottom_left "49.9415476869,14.2162566185"
                    end
                  end
                end
              end
            }.to_hash

            assert_equal 1, response['hits']['hits'].size
            assert_equal 'Vyšehrad', response['hits']['hits'][0]['_source']['name']
          end

          should "find documents within the distance specified with a hash" do
            response = @client.search index: 'places', body: search {
              query do
                bool do
                  filter do
                    geo_distance location: '50.090223,14.399590', distance: '5km'
                  end
                end
              end
            }.to_hash

            assert_equal 1, response['hits']['hits'].size
            assert_equal 'Vyšehrad', response['hits']['hits'][0]['_source']['name']
          end

          should "find documents within the distance specified with a block" do
            response = @client.search index: 'places', body: search {
              query do
                bool do
                  filter do
                    geo_distance :location do
                      lat '50.090223'
                      lon '14.399590'
                      distance '5km'
                    end
                  end
                end
              end
            }.to_hash

            assert_equal 1, response['hits']['hits'].size
            assert_equal 'Vyšehrad', response['hits']['hits'][0]['_source']['name']
          end

          should "find documents within the geographical distance range" do
            response = @client.search index: 'places', body: search {
              query do
                bool do
                  filter do
                    geo_distance location: { lat: '50.090223', lon: '14.399590' },
                                       distance: '50km'
                  end
                end
              end
              aggregation :distance_ranges do
                geo_distance do
                  field  :location
                  origin '50.090223,14.399590'
                  unit   'km'
                  ranges [ { from: 10, to: 50 } ]

                  aggregation :results do
                    top_hits _source: { include: 'name' }
                  end
                end
              end
            }.to_hash

            assert_equal 2, response['hits']['hits'].size

            bucket = response['aggregations']['distance_ranges']['buckets'][0]

            assert_equal 1, bucket['doc_count']
            assert_equal 1, bucket['results']['hits']['hits'].size
            assert_equal 'Karlštejn', bucket['results']['hits']['hits'][0]['_source']['name']
          end

          should "find documents within the polygon" do
            response = @client.search index: 'places', body: search {
              query do
                bool do
                  filter do
                    geo_polygon :location do
                      points [
                       [14.2244355,49.9419006],
                       [14.2244355,50.1774301],
                       [14.7067869,50.1774301],
                       [14.7067869,49.9419006],
                       [14.2244355,49.9419006]
                      ]
                    end
                  end
                end
              end
            }.to_hash

            assert_equal 1, response['hits']['hits'].size
            assert_equal 'Vyšehrad', response['hits']['hits'][0]['_source']['name']
          end
        end
      end
    end
  end
end
