require 'test_helper'

module Elasticsearch
  module Test
    module Queries
      class BoolTest < ::Test::Unit::TestCase
        include Elasticsearch::DSL::Search::Queries

        context "Bool Query" do
          subject { Bool.new }

          should "be converted to a Hash" do
            assert_equal({ bool: {} }, subject.to_hash)
          end

          should "take a Hash" do
            subject = Bool.new must: [ {match: { foo: 'bar' }} ]

            assert_equal( { bool: { must: [ {match: { foo: 'bar' }} ] } }, subject.to_hash )
          end

          should "take a block" do
            subject = Bool.new do
              must { match foo: 'bar' }
            end

            assert_equal( { bool: {must: [ {match: { foo: 'bar' }} ] } }, subject.to_hash )
          end

          should "take a block with multiple methods" do
            subject = Bool.new do
              must     { match foo: 'bar' }
              must_not { match moo: 'bam' }
              should   { match xoo: 'bax' }
            end

            assert_equal( { bool:
                            { must:     [ {match: { foo: 'bar' }} ],
                              must_not: [ {match: { moo: 'bam' }} ],
                              should:   [ {match: { xoo: 'bax' }} ]
                            }
                          },
                          subject.to_hash )
          end

          should "take a block with multiple conditions" do
            subject = Bool.new do
              must do
                match foo: 'bar'
              end

              must do
                match moo: 'bam'
              end

              should do
                match xoo: 'bax'
              end

              should do
                match zoo: 'baz'
              end
            end

            # Make sure we're not additive
            subject.to_hash
            subject.to_hash

            assert_equal( { bool:
                            { must:     [ {match: { foo: 'bar' }}, {match: { moo: 'bam' }} ],
                              should:   [ {match: { xoo: 'bax' }}, {match: { zoo: 'baz' }} ]
                            }
                          },
                          subject.to_hash )
          end

          should "take method calls" do
            subject = Bool.new

            subject.must { match foo: 'bar' }
            assert_equal( { bool: { must: [ {match: { foo: 'bar' }} ] } }, subject.to_hash )

            subject.must { match moo: 'bam' }
            assert_equal( { bool: { must: [ {match: { foo: 'bar' }}, {match: { moo: 'bam' }} ]} },
                          subject.to_hash )

            subject.should { match xoo: 'bax' }
            assert_equal( { bool:
                            { must:   [ {match: { foo: 'bar' }}, {match: { moo: 'bam' }} ],
                              should: [ {match: { xoo: 'bax' }} ] }
                          },
                          subject.to_hash )
          end

          should "allow adding a filter" do
            subject = Bool.new
            subject.filter do
              term foo: 'bar'
            end

            assert_equal( { bool: { filter: { term: { foo: "bar" } } } }, subject.to_hash)
          end

          should "be chainable" do
            subject = Bool.new

            assert_instance_of Bool, subject.must     { match foo: 'bar' }
            assert_instance_of Bool, subject.must     { match foo: 'bar' }.must { match moo: 'bam' }
            assert_instance_of Bool, subject.must_not { match foo: 'bar' }
            assert_instance_of Bool, subject.should   { match foo: 'bar' }
          end
        end
      end
    end
  end
end
