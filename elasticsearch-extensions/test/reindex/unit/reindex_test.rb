require 'elasticsearch'
require 'test_helper'

class Elasticsearch::Extensions::ReindexTest < Test::Unit::TestCase
  context "reindex" do
    should "scroll and bulk insert" do
      @subject = Elasticsearch::Client.new
      search_opts = { index: 'foo-index',
                      search_type: 'scan',
                      scroll: '5m',
                      size: 500 }
      scroll_opts = { scroll_id: 'bar-id',
                      scroll: '5m' }
      doc = { '_id' => 'quux',
              '_type' => 'foo-type',
              '_source' => { 'field1' => 'foobar' } }
      scroll_rsp = { 'hits' => { 'hits' => [doc] } }
      empty_scroll_rsp = { 'hits' => { 'hits' => [] } }
      bulk_body = [{ index: { '_index' => 'bar-index',
                              '_type' => doc['_type'],
                              '_id' => doc['_id'],
                              'data' => doc['_source'] } }]

      @subject.expects(:search).with(search_opts).returns({ '_scroll_id' => 'bar-id' })
      @subject.expects(:scroll).with(scroll_opts).returns(scroll_rsp)
      @subject.expects(:scroll).with({ scroll_id: nil, scroll: '5m' }).returns(empty_scroll_rsp)
      @subject.expects(:bulk).with(body: bulk_body).returns([])

      Elasticsearch::Extensions::Reindex.new(client: @subject,
                                             src_index: 'foo-index',
                                             target_index: 'bar-index')
    end
  end
end
