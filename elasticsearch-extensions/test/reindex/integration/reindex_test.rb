require 'test_helper'
require 'elasticsearch/extensions/reindex'

class Elasticsearch::Extensions::ReindexIntegrationTest < Elasticsearch::Test::IntegrationTestCase
  context "The Reindex extension" do
    setup do
      @port = (ENV['TEST_CLUSTER_PORT'] || 9250).to_i

      @logger =  ::Logger.new(STDERR)
      @logger.formatter = proc do |severity, datetime, progname, msg|
        color = case severity
          when /INFO/ then :green
          when /ERROR|WARN|FATAL/ then :red
          when /DEBUG/ then :cyan
          else :white
        end
        ANSI.ansi(severity[0] + ' ', color, :faint) + ANSI.ansi(msg, :white, :faint) + "\n"
      end

      @client = Elasticsearch::Client.new host: "localhost:#{@port}", logger: @logger
      @client.indices.delete index: '_all'

      @client.index index: 'test1', type: 'd', id: 1, body: { title: 'TEST 1', category: 'one' }
      @client.index index: 'test1', type: 'd', id: 2, body: { title: 'TEST 2', category: 'two' }
      @client.index index: 'test1', type: 'd', id: 3, body: { title: 'TEST 3', category: 'three' }
      @client.indices.refresh index: 'test1'

      @client.indices.create index: 'test2'

      @client.cluster.health wait_for_status: 'yellow'
    end

    teardown do
      @client.indices.delete index: '_all'
    end

    should "copy documents from one index to another" do
      reindex = Elasticsearch::Extensions::Reindex.new \
                  source: { index: 'test1', client: @client },
                  target: { index: 'test2' },
                  batch_size: 2,
                  refresh: true

      result = reindex.perform

      assert_equal 0, result[:errors]
      assert_equal 3, @client.search(index: 'test2')['hits']['total']
    end

    should "copy documents with parent/child relationship" do
      mapping = { mappings: { p: {}, c: { _parent: { type: 'p' } } } }
      @client.indices.create index: 'test_parent_1', body: mapping
      @client.indices.create index: 'test_parent_2', body: mapping

      @client.index index: 'test_parent_1', type: 'p', id: 1, body: { title: 'Parent 1' }
      @client.index index: 'test_parent_1', type: 'p', id: 2, body: { title: 'Parent 2' }
      @client.index index: 'test_parent_1', type: 'c', parent: 1, body: { title: 'Child One' }
      @client.index index: 'test_parent_1', type: 'c', parent: 1, body: { title: 'Child Two' }

      @client.indices.refresh index: 'test_parent_1'

      reindex = Elasticsearch::Extensions::Reindex.new \
                  source: { index: 'test_parent_1', client: @client },
                  target: { index: 'test_parent_2' },
                  batch_size: 2,
                  refresh: true

      result = reindex.perform

      assert_equal 0, result[:errors]
      assert_equal 4, @client.search(index: 'test_parent_2')['hits']['total']

      response = @client.search index: 'test_parent_2', body: {
        query: { has_child: { type: 'c', query: { match: { title: 'two' } } } } }

      assert_equal 1, response['hits']['hits'].size
      assert_equal 'Parent 1', response['hits']['hits'][0]['_source']['title']
    end

    should "transform documents with a lambda" do
      reindex = Elasticsearch::Extensions::Reindex.new \
                  source: { index: 'test1', client: @client },
                  target: { index: 'test2' },
                  transform: lambda { |d| d['_source']['category'].upcase! },
                  refresh: true

      result = reindex.perform

      assert_equal 0, result[:errors]
      assert_equal 3, @client.search(index: 'test2')['hits']['total']
      assert_equal 'ONE', @client.get(index: 'test2', type: 'd', id: 1)['_source']['category']
    end

    should "return the number of errors" do
      @client.indices.create index: 'test3', body: { mappings: { d: { properties: { category: { type: 'integer' } }}}}
      @client.cluster.health wait_for_status: 'yellow'

      reindex = Elasticsearch::Extensions::Reindex.new \
                  source: { index: 'test1', client: @client },
                  target: { index: 'test3' }

      result = reindex.perform

      @client.indices.refresh index: 'test3'

      assert_equal 3, result[:errors]
      assert_equal 0, @client.search(index: 'test3')['hits']['total']
    end

    should "reindex via the API integration" do
      @client.indices.create index: 'test4'

      @client.reindex source: { index: 'test1' }, target: { index: 'test4' }
      @client.indices.refresh index: 'test4'

      assert_equal 3, @client.search(index: 'test4')['hits']['total']
    end
  end

end
