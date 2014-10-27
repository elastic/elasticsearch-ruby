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

        should "have an option method" do
          class DummyComponentWithOptionMethod
            include Elasticsearch::DSL::Search::BaseComponent
            option_method :bar
          end

          subject = DummyComponentWithOptionMethod.new :foo
          assert_respond_to subject, :bar

          subject.bar

          assert subject.to_hash[:dummycomponentwithoptionmethod][:foo].key?(:bar),
                 "#{subject.to_hash.inspect} doesn't have the :bar key"
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
      end
    end
  end
end
