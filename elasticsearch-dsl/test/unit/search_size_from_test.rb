require 'test_helper'

module Elasticsearch
  module Test
    class SearchSizeTest < ::Test::Unit::TestCase
      context "Search pagination" do

        should "encode the size parameter" do
          subject = Elasticsearch::DSL::Search::Search.new do
            size 5
          end
          assert_equal( { size: 5 }, subject.to_hash )
        end

        should "encode the from parameter" do
          subject = Elasticsearch::DSL::Search::Search.new do
            from 5
          end
          assert_equal( { from: 5 }, subject.to_hash )
        end

      end
    end
  end
end
