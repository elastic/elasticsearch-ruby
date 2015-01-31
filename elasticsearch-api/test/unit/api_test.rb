# encoding: UTF-8

require 'test_helper'

module Elasticsearch
  module Test
    class APITest < ::Test::Unit::TestCase

      context "The API module" do

        should "access the settings" do
          assert_not_nil Elasticsearch::API.settings
        end

        should "allow to set settings" do
          assert_nothing_raised { Elasticsearch::API.settings[:foo] = 'bar' }
          assert_equal 'bar', Elasticsearch::API.settings[:foo]
        end

      end

    end
  end
end
