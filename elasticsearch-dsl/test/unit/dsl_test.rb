# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require 'test_helper'

module Elasticsearch
  module Test
    class DSLTest < ::Elasticsearch::Test::UnitTestCase
      context "The DSL" do
        class DummyDSLReceiver
          include Elasticsearch::DSL
        end

        should "include the module in receiver" do
          assert_contains DummyDSLReceiver.included_modules, Elasticsearch::DSL
          assert_contains DummyDSLReceiver.included_modules, Elasticsearch::DSL::Search
        end
      end
    end
  end
end
