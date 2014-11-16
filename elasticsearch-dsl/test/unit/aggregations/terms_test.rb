require 'test_helper'

module Elasticsearch
  module Test
    module Aggregations
      class TermsTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Aggregations

        context "Term aggregation" do
          should "be converted to a Hash" do
            @subject = Terms.new field: 'test'

            assert_equal({:terms=>{:field=>"test"}}, @subject.to_hash)
          end
        end
      end
    end
  end
end
