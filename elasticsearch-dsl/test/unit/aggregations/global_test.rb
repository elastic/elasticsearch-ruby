require 'test_helper'

module Elasticsearch
  module Test
    module Aggregations
      class GlobalTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Aggregations

        context "Global agg" do
          subject { Global.new }

          should "be converted to a Hash" do
            assert_equal({ global: {} }, subject.to_hash)
          end
          
        end
      end
    end
  end
end
