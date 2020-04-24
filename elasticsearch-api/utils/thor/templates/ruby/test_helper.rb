# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

RUBY_1_8 = defined?(RUBY_VERSION) && RUBY_VERSION < '1.9'

require 'rubygems' if RUBY_1_8

require 'simplecov' and SimpleCov.start { add_filter "/test|test_/" } if ENV["COVERAGE"]

require 'test/unit'
require 'shoulda-context'
require 'mocha/setup'
require 'turn' unless ENV["TM_FILEPATH"] || ENV["NOTURN"] || RUBY_1_8

require 'require-prof' if ENV["REQUIRE_PROF"]
Dir[ File.expand_path('../../lib/elasticsearch/api/**/*.rb', __FILE__) ].each do |f|
  puts 'Loading: ' + f.to_s if ENV['DEBUG']
  require f
end
RequireProf.print_timing_infos if ENV["REQUIRE_PROF"]

module Elasticsearch
  module Utils
    def __validate_and_extract_params(*args)
      {}
    end

    extend self
  end

  module Test
    def __full_namespace(o)
      o.constants.inject([o]) do |sum, c|
        m   = o.const_get(c.to_s.to_sym)
        sum << __full_namespace(m).flatten if m.is_a?(Module)
        sum
      end.flatten
    end; module_function :__full_namespace

    module Namespace
      def cluster
        self
      end
    end

    class FakeClient
      # Include all "Actions" modules into the fake client
      Elasticsearch::Test.__full_namespace(Elasticsearch::API).select { |m| m.to_s =~ /Actions$/ }.each do |m|
        puts "Including: #{m}" if ENV['DEBUG']
        include m
      end

      # Include the fake "namespace" methods in the client
      include Namespace

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
  end
end
