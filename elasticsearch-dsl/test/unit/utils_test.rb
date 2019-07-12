# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'test_helper'

module Elasticsearch
  module Test
    class UtilsTest < ::Elasticsearch::Test::UnitTestCase
      context "Utils" do
        should "convert a string to camelcase" do
          assert_equal 'Foo', Elasticsearch::DSL::Utils.__camelize('foo')
        end

        should "convert an underscored string to camelcase" do
          assert_equal 'FooBar', Elasticsearch::DSL::Utils.__camelize('foo_bar')
        end

        should "convert a symbol" do
          assert_equal 'FooBar', Elasticsearch::DSL::Utils.__camelize(:foo_bar)
        end
      end
    end
  end
end
