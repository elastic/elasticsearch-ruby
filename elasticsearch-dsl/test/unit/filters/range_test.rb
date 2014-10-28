require 'test_helper'

module Elasticsearch
  module Test
    module Filters
      class RangeTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Filters

        context "Range Filter" do
          should "take a Hash" do
            @subject = Range.new age: { gte: 10, lte: 20 }

            assert_equal({ range: { age: { gte: 10, lte: 20 } } }, @subject.to_hash)
          end

          should "take a block" do
            @subject = Range.new :age do gte 10 and lte 20 end

            assert_equal({ range: { age: { gte: 10, lte: 20 } } }, @subject.to_hash)
          end
        end
      end
    end
  end
end
