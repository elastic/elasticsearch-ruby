require 'test_helper'

module Elasticsearch
  module Test
    class XPackSslCertificatesTest < Minitest::Test

      context "XPack Ssl: Certificates" do
        subject { FakeClient.new }

        should "perform correct request" do
          subject.expects(:perform_request).with do |method, url, params, body|
            assert_equal 'GET', method
            assert_equal '_xpack/ssl/certificates', url
            assert_equal Hash.new, params
            assert_nil   body
            true
          end.returns(FakeResponse.new)

          subject.xpack.ssl.certificates
        end

      end

    end
  end
end
