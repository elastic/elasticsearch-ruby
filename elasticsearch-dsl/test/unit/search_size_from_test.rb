# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

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
