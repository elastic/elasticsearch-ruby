require 'test_helper'
require 'logger'

# Mock the Backup modules and classes so we're not depending on the gem in the unit test
#
module Backup
  class Error < StandardError; end

  class Logger < ::Logger
    def self.logger
      self.new($stderr)
    end
  end

  module Config
    module DSL
    end
  end

  module Database
    class Base
      def initialize(model, database_id = nil)
      end

      def dump_path;     'dump_path'; end
      def dump_filename; 'dump_filename'; end

      def log!(*args)
        puts "LOGGING..." if ENV['DEBUG']
      end

      def perform!
        puts "PERFORMING..." if ENV['DEBUG']
      end
    end
  end
end

require 'elasticsearch/extensions/backup'

class Elasticsearch::Extensions::BackupTest < Elasticsearch::Test::UnitTestCase
  context "The Backup gem extension" do
    setup do
      @model = stub trigger: true
      @subject = ::Backup::Database::Elasticsearch.new(@model)
    end

    should "have a client" do
      assert_instance_of Elasticsearch::Transport::Client, @subject.client
    end

    should "have a path" do
      assert_instance_of Pathname, @subject.path
    end

    should "have defaults" do
      assert_equal 'http://localhost:9200', @subject.url
      assert_equal '_all', @subject.indices
    end

    should "be configurable" do
      @subject = ::Backup::Database::Elasticsearch.new(@model) do |db|
        db.url = 'https://example.com'
        db.indices = 'foo,bar'
      end

      assert_equal 'https://example.com', @subject.url
      assert_equal 'foo,bar', @subject.indices

      assert_equal 'example.com', @subject.client.transport.connections.first.host[:host]
    end

    should "perform the backup" do
      @subject.expects(:__perform_single)
      @subject.perform!
    end

    should "raise an expection for an unsupported type of backup" do
      @subject = ::Backup::Database::Elasticsearch.new(@model) { |db| db.mode = 'foobar' }
      assert_raise ::Backup::Database::Elasticsearch::Error do
        @subject.perform!
      end
    end

    should "scan and scroll the index" do
      @subject = ::Backup::Database::Elasticsearch.new(@model) { |db| db.indices = 'test' }

      @subject.client
        .expects(:search)
        .with do |params|
          assert_equal 'test', params[:index]
          true # Thanks, Ruby 2.2
        end
        .returns({"_scroll_id" => "abc123"})

      @subject.client
        .expects(:scroll)
        .twice
        .returns({"_scroll_id" => "def456",
                  "hits" => { "hits" => [ {"_index"=>"test", "_type"=>"doc", "_id"=>"1", "_source"=>{"title"=>"Test"}} ] }
                })
        .then
        .returns({"_scroll_id" => "ghi789",
                  "hits" => { "hits" => [] }
                })

      @subject.__perform_single
    end
  end
end
