require 'test_helper'
require 'elasticsearch/extensions/reindex'

class Elasticsearch::Extensions::ReindexTest < Elasticsearch::Test::UnitTestCase
  context "The Reindex extension module" do
    DEFAULT_OPTIONS = { source: { index: 'foo', client: Object.new }, target: { index: 'bar' } }

    should "require options" do
      assert_raise ArgumentError do
        Elasticsearch::Extensions::Reindex.new
      end
    end

    should "allow to initialize the class" do
      assert_instance_of Elasticsearch::Extensions::Reindex::Reindex,
                         Elasticsearch::Extensions::Reindex.new(DEFAULT_OPTIONS)
    end

    should "add the reindex to the API and client" do
      assert_includes Elasticsearch::API::Actions.public_instance_methods.sort, :reindex
      assert_respond_to Elasticsearch::Client.new, :reindex
    end

    should "pass the client when used in API mode" do
      client = Elasticsearch::Client.new

      Elasticsearch::Extensions::Reindex::Reindex
        .expects(:new)
        .with({source: { client: client }})
        .returns(stub perform: {})

      client.reindex
    end

    context "when performing the operation" do
      setup do
        d = { '_id' => 'foo', '_type' => 'type', '_source' => { 'foo' => 'bar' } }
        @default_response = { 'hits' => { 'hits' => [d] } }
        @empty_response   = { 'hits' => { 'hits' => [] } }
        @bulk_request     = [{ index: {
                                '_index' => 'bar',
                                '_type'  => d['_type'],
                                '_id'    => d['_id'],
                                'data'   => d['_source']
                               } }]
        @bulk_response    = {'errors'=>false, 'items' => [{'index' => {}}, {'index' => {}}]}
        @bulk_response_error = {'errors'=>true, 'items' => [{'index' => {}}, {'index' => {'error' => 'FOOBAR'}}]}
      end

      should "scroll through the index and save batches in bulk" do
        client  = mock()
        subject = Elasticsearch::Extensions::Reindex.new source: { index: 'foo', client: client },
                                                         target: { index: 'bar' }

        client.expects(:search)
          .returns({ '_scroll_id' => 'scroll_id_1' }.merge(Marshal.load(Marshal.dump(@default_response))))
        client.expects(:scroll)
          .returns(Marshal.load(Marshal.dump(@default_response)))
          .then
          .returns(@empty_response).times(2)
        client.expects(:bulk)
          .with(body: @bulk_request)
          .returns(@bulk_response).times(2)

        result = subject.perform

        assert_equal 0, result[:errors]
      end

      should "return the number of errors" do
        client  = mock()
        subject = Elasticsearch::Extensions::Reindex.new source: { index: 'foo', client: client },
                                                         target: { index: 'bar' }

        client.expects(:search).returns({ '_scroll_id' => 'scroll_id_1' }.merge(@default_response))
        client.expects(:scroll).returns(@empty_response)
        client.expects(:bulk).with(body: @bulk_request).returns(@bulk_response_error)

        result = subject.perform

        assert_equal 1, result[:errors]
      end

      should "transform the documents with a lambda" do
        client  = mock()
        subject = Elasticsearch::Extensions::Reindex.new \
          source: { index: 'foo', client: client },
          target: { index: 'bar' },
          transform: lambda { |d| d['_source']['foo'].upcase!; d }

        client.expects(:search).returns({ '_scroll_id' => 'scroll_id_1' }.merge(@default_response))
        client.expects(:scroll).returns(@empty_response)
        client.expects(:bulk).with do |arguments|
                assert_equal 'BAR', arguments[:body][0][:index]['data']['foo']
                true
              end
              .returns(@bulk_response)

        result = subject.perform

        assert_equal 0, result[:errors]
      end
    end

  end
end
