require 'test_helper'

module Elasticsearch
  module Test
    module Filters
      class NotTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Filters

        context "Not filter" do
          subject { Not.new }

          should "be converted to a Hash" do
            assert_equal({ not: {} }, subject.to_hash)
          end

          should "take a Hash" do
            subject = Not.new filters: [ { term: { foo: 'bar' } } ]
            assert_equal({ not: { filters: [ { term: { foo: 'bar' } } ] } }, subject.to_hash)
          end

          should "take a block" do
            subject = Not.new do
              term foo: 'bar'
              term moo: 'mam'
            end
            assert_equal({not: [ {term: { foo: 'bar'}}, {term: { moo: 'mam'}} ]}, subject.to_hash)
          end

          should "behave like an Enumerable" do
            subject = Not.new
            subject << { term: { foo: 'bar' } }

            assert_equal 1, subject.size
            assert subject.any? { |d| d[:term] == { foo: 'bar' } }
          end

          should "behave like an Array" do
            subject = Not.new

            assert subject.empty?

            subject << { term: { foo: 'bar' } }
            subject << { term: { moo: 'xam' } }

            assert ! subject.empty?

            assert_equal({ not: [ { term: { foo: 'bar' } }, { term: { moo: 'xam' } } ] }, subject.to_hash)
          end
        end
      end
    end
  end
end
