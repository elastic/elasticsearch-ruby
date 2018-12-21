require 'test_helper'

module Elasticsearch
  module Test
    class XPackSecurityGetPrivilegesTest < Minitest::Test

      context "XPack Security: Get privileges" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/privilege', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.get_privileges
        end

        should "perform correct request for an application but no name" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/privilege/foo', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.get_privileges application: 'foo'
        end

        should "perform correct request for an application and a single name" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/privilege/foo/bar', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.get_privileges application: 'foo', name: 'bar'
        end

        should "perform correct request for an application and multiple names" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/security/privilege/foo/bar,baz', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.security.get_privileges application: 'foo', name: ['bar', 'baz']
        end
      end

    end
  end
end
