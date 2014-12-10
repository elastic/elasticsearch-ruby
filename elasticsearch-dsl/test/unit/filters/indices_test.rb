require 'test_helper'

module Elasticsearch
  module Test
    module Filters
      class IndicesTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Filters

        context "Indices filter" do
          subject { Indices.new }

          should "be converted to a Hash" do
            assert_equal({ indices: {} }, subject.to_hash)
          end

          should "have option methods" do
            subject = Indices.new

            subject.indices 'bar'
            subject.filter 'bar'
            subject.no_match_filter 'bar'

            assert_equal %w[ filter indices no_match_filter ],
                         subject.to_hash[:indices].keys.map(&:to_s).sort
            assert_equal 'bar', subject.to_hash[:indices][:indices]
          end

          should "take a block" do
            subject = Indices.new do
              indices 'bar'
            end
            assert_equal({indices: { indices: 'bar' } }, subject.to_hash)
          end

          should "take a block for option method" do
            subject = HasChild.new do
              type 'bar'
              filter do
                term foo: 'bar'
              end
            end
            assert_equal({ has_child: { type: 'bar', filter: { term: { foo: 'bar' } } } }, subject.to_hash)
          end
        end
      end
    end
  end
end
