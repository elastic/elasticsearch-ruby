require 'test_helper'

module Elasticsearch
  module Test
    module Queries
      class MatchTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Queries

        context "MatchQuery" do
          setup { @subject = Match.new message: 'test' }

          should "take a concrete value" do
            @subject = Match.new message: 'test'

            assert_equal({:match=>{:message=>"test"}}, @subject.to_hash)
          end

          should "take a Hash" do
            @subject = Match.new message: { query: 'test', operator: 'and' }

            assert_equal({:match=>{:message=>{:query=>"test", :operator=>"and"}}}, @subject.to_hash)
          end

          should "take a block" do
            @subject = Match.new :message do
              query    'test'
              operator 'and'
              boost    2
            end

            assert_equal({:match=>{:message=>{:query=>"test", :operator=>"and", :boost=>2}}}, @subject.to_hash)
          end

          should "take a method call" do
            @subject = Match.new :message
            @subject.query    'test'
            @subject.operator 'and'

            assert_equal({:match=>{:message=>{:query=>"test", :operator=>"and"}}}, @subject.to_hash)
          end

        end
      end
    end
  end
end
