require 'test_helper'

module Elasticsearch
  module Test
    class BaseComponentTest < ::Test::Unit::TestCase
      context "BaseComponent" do

        class DummyComponent
          include Elasticsearch::DSL::Search::BaseComponent
        end

        class DummyComponentWithAName
          include Elasticsearch::DSL::Search::BaseComponent
          name :foo
        end

        class DummyComponentWithNewName
          include Elasticsearch::DSL::Search::BaseComponent
        end

        subject { DummyComponent.new :foo }

        should "have a name" do
          assert_equal :dummycomponent, subject.name
        end

        should "have a custom name" do
          assert_equal :foo, DummyComponentWithAName.new.name
        end

        should "allow to set a name" do
          DummyComponentWithNewName.name :foo
          assert_equal :foo, DummyComponentWithNewName.new.name
          assert_equal :foo, DummyComponentWithNewName.name

          DummyComponentWithNewName.name = :bar
          assert_equal :bar, DummyComponentWithNewName.name
          assert_equal :bar, DummyComponentWithNewName.new.name
        end

        should "initialize the hash" do
          assert_instance_of Hash, subject.to_hash
        end

        should "have an empty Hash as args by default" do
          subject = DummyComponentWithNewName.new
          assert_equal({}, subject.instance_variable_get(:@args))
        end

        should "have an option method with args" do
          class DummyComponentWithOptionMethod
            include Elasticsearch::DSL::Search::BaseComponent
            option_method :bar
          end

          subject = DummyComponentWithOptionMethod.new :foo
          assert_respond_to subject, :bar

          subject.bar 'BAM'
          assert_equal({ dummycomponentwithoptionmethod: { foo: { bar: 'BAM' } } }, subject.to_hash)
        end

        should "have an option method without args" do
          class DummyComponentWithOptionMethod
            include Elasticsearch::DSL::Search::BaseComponent
            option_method :bar
          end

          subject = DummyComponentWithOptionMethod.new
          assert_respond_to subject, :bar

          subject.bar 'BAM'
          assert_equal({ dummycomponentwithoptionmethod: { bar: 'BAM' } }, subject.to_hash)
        end

        should "define a custom option method" do
          class DummyComponentWithCustomOptionMethod
            include Elasticsearch::DSL::Search::BaseComponent
            option_method :bar, lambda { |*args| @hash = { :foo => 'bar' } }
          end

          subject = DummyComponentWithCustomOptionMethod.new
          subject.bar

          assert_equal 'bar', subject.instance_variable_get(:@hash)[:foo]
        end

        should "execute the passed block" do
          subject = DummyComponent.new(:foo) { @foo = 'BAR' }

          assert_respond_to  subject, :call
          assert_instance_of DummyComponent, subject.call
          assert_equal       'BAR', subject.instance_variable_get(:@foo)
        end

        context "to_hash conversion" do

          should "build the hash with the block with args" do
            subject = DummyComponent.new :foo do
              @hash[:dummycomponent][:foo].update moo: 'xoo'
            end

            assert_equal({dummycomponent: { foo: { moo: 'xoo' } } }, subject.to_hash )
          end

          should "build the hash with the block without args" do
            subject = DummyComponent.new do
              @hash[:dummycomponent].update moo: 'xoo'
            end

            assert_equal({dummycomponent: { moo: 'xoo' } }, subject.to_hash )
          end

          should "build the hash with the option method" do
            class DummyComponentWithOptionMethod
              include Elasticsearch::DSL::Search::BaseComponent
              option_method :foo
            end

            subject = DummyComponentWithOptionMethod.new do
              subject.foo 'bar'
            end

            assert_equal({ dummycomponentwithoptionmethod: { foo: 'bar' } }, subject.to_hash)
          end

          should "build the hash with the passed args" do
            subject = DummyComponent.new foo: 'bar'

            assert_equal({ dummycomponent: { foo: 'bar' } }, subject.to_hash)
          end

          should "return the already built hash" do
            subject = DummyComponent.new
            subject.instance_variable_set(:@hash, { foo: 'bar' })

            assert_equal({ foo: 'bar' }, subject.to_hash)
          end

        end
      end
    end
  end
end
