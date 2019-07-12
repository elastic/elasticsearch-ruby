# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'test_helper'

module Elasticsearch
  module Test
    class SearchSizeTest < ::Elasticsearch::Test::UnitTestCase
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

        should "have getter methods" do
          subject = Elasticsearch::DSL::Search::Search.new
          assert_nil subject.size
          assert_nil subject.from
          subject.size = 5
          subject.from = 5
          assert_equal 5, subject.size
          assert_equal 5, subject.from
        end

        should "have setter methods" do
          subject = Elasticsearch::DSL::Search::Search.new
          subject.size = 5
          subject.from = 5
          assert_equal 5, subject.size
          assert_equal 5, subject.from
          assert_equal( { size: 5, from: 5 }, subject.to_hash )
        end
      end
    end
  end
end
