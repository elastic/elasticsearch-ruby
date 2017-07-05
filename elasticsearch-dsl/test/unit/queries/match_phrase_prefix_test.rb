require 'test_helper'

module Elasticsearch
  module Test
    module Queries
      class MatchPhrasePrefixTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Queries

        context "Match Phrase Prefix Query" do
          subject { MatchPhrasePrefix.new }

          should "be converted to a Hash" do
            assert_equal({ match_phrase_prefix: {} }, subject.to_hash)
          end

          should "take a concrete value" do
            subject = MatchPhrasePrefix.new message: 'test'

            assert_equal({match_phrase_prefix: {message: "test"}}, subject.to_hash)
          end

          should "have option methods" do
            subject = MatchPhrasePrefix.new

            subject.query    'bar'
            subject.boost    10
            subject.max_expansions     1

            assert_equal %w[ boost max_expansions query ],
                         subject.to_hash[:match_phrase_prefix].keys.map(&:to_s).sort
            assert_equal 'bar', subject.to_hash[:match_phrase_prefix][:query]
          end

          should "take a Hash" do
            subject = MatchPhrasePrefix.new message: { query: 'test' }

            assert_equal({match_phrase_prefix: {message: {query: "test" }}}, subject.to_hash)
          end

          should "take a block" do
            subject = MatchPhrasePrefix.new :message do
              query          'test'
              boost          2
              max_expansions 1
            end

            assert_equal({match_phrase_prefix: {message: {query: "test", max_expansions: 1, boost: 2 }}},
                         subject.to_hash)
          end

          should "take a method call" do
            subject = MatchPhrasePrefix.new :message
            subject.query    'test'

            assert_equal({match_phrase_prefix: {message: {query: "test" }}}, subject.to_hash)
          end

        end
      end
    end
  end
end
