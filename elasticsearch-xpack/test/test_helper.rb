$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'pathname'

require 'minitest/autorun'
require 'minitest/reporters'
require 'shoulda/context'
require 'mocha/mini_test'

require 'ansi'

require 'elasticsearch/xpack'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

module Minitest
  class Test
    def assert_nothing_raised(*args)
      begin
        line = __LINE__
        yield
      rescue Exception => e
        raise MiniTest::Assertion, "Exception raised:\n<#{e.class}>", e.backtrace
      end
      true
    end
  end
end

module Elasticsearch
  module Test
    class FakeClient
      def xpack
        @xpack_client ||= Elasticsearch::XPack::API::Client.new(self)
      end

      def perform_request(method, path, params, body)
        puts "PERFORMING REQUEST:", "--> #{method.to_s.upcase} #{path} #{params} #{body}"
        FakeResponse.new(200, 'FAKE', {})
      end
    end

    FakeResponse = Struct.new(:status, :body, :headers) do
      def status
        values[0] || 200
      end
      def body
        values[1] || '{}'
      end
      def headers
        values[2] || {}
      end
    end

    class NotFound < StandardError; end
  end
end
