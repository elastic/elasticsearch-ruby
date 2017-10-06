require 'test_helper'

module Elasticsearch
  module Test
    module Queries
      class MatchPhraseTest < ::Elasticsearch::Test::UnitTestCase
        include Elasticsearch::DSL::Search::Queries

        context "Match Phrase Query" do
          subject { MatchPhrase.new }

          should "be converted to a Hash" do
            assert_equal({ match_phrase: {} }, subject.to_hash)
          end

          should "take a concrete value" do
            subject = MatchPhrase.new message: 'test'

            assert_equal({match_phrase: {message: "test"}}, subject.to_hash)
          end

          should "have option methods" do
            subject = MatchPhrase.new

            subject.query    'bar'
            subject.analyzer 'standard'
            subject.boost    10
            subject.slop     1

            assert_equal %w[ analyzer boost query slop ],
                         subject.to_hash[:match_phrase].keys.map(&:to_s).sort
            assert_equal 'bar', subject.to_hash[:match_phrase][:query]
          end

          should "take a Hash" do
            subject = MatchPhrase.new message: { query: 'test' }

            assert_equal({match_phrase: {message: {query: "test" }}}, subject.to_hash)
          end

          should "take a block" do
            subject = MatchPhrase.new :message do
              query     'test'
              slop      1
              boost     2
            end

            assert_equal({match_phrase: {message: {query: "test", slop: 1, boost: 2 }}},
                         subject.to_hash)
          end

          should "take a method call" do
            subject = MatchPhrase.new :message
            subject.query    'test'

            assert_equal({match_phrase: {message: {query: "test" }}}, subject.to_hash)
          end

        end
      end
    end
  end
end
