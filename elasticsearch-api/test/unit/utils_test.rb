require 'test_helper'

module Elasticsearch
  module Test
    class UtilsTest < ::Test::Unit::TestCase
      include Elasticsearch::API::Utils

      context "Utils" do

        context "__listify" do

          should "create a list from single value" do
            assert_equal 'foo', __listify('foo')
          end

          should "create a list from an array" do
            assert_equal 'foo,bar', __listify(['foo', 'bar'])
          end

          should "create a list from multiple arguments" do
            assert_equal 'foo,bar', __listify('foo', 'bar')
          end

          should "ignore nil values" do
            assert_equal 'foo,bar', __listify(['foo', nil, 'bar'])
          end

        end

        context "__pathify" do

          should "create a path from single value" do
            assert_equal 'foo', __pathify('foo')
          end

          should "create a path from an array" do
            assert_equal 'foo/bar', __pathify(['foo', 'bar'])
          end

          should "ignore nil values" do
            assert_equal 'foo/bar', __pathify(['foo', nil, 'bar'])
          end

          should "ignore empty string values" do
            assert_equal 'foo/bar', __pathify(['foo', '', 'bar'])
          end

        end

      end
    end
  end
end
