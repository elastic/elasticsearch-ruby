module Elasticsearch
  module Extensions
    module Test
      # Startup/shutdown support for test suites
      #
      # Example:
      #
      #     class MyTest < Test::Unit::TestCase
      #       extend Elasticsearch::Extensions::Test::StartupShutdown
      #
      #       startup  { puts "Suite starting up..." }
      #       shutdown { puts "Suite shutting down..." }
      #     end
      #
      # *** IMPORTANT NOTE: **********************************************************
      #
      # You have to register the handler for shutdown before requiring 'test/unit':
      #
      #     # File: test_helper.rb
      #     at_exit { MyTest.__run_at_exit_hooks }
      #     require 'test/unit'
      #
      # The API follows Test::Unit 2.0
      # <https://github.com/test-unit/test-unit/blob/master/lib/test/unit/testcase.rb>
      #
      module StartupShutdown
        @@started           = false
        @@shutdown_blocks ||= []

        def startup &block
          return if started?
          @@started = true
          yield block if block_given?
        end

        def shutdown &block
          @@shutdown_blocks << block if block_given?
        end

        def started?
          !! @@started
        end

        def __run_at_exit_hooks
          return unless started?
          STDERR.puts ANSI.faint("Running at_exit hooks...")
          puts ANSI.faint('-'*80)
          @@shutdown_blocks.each { |b| b.call }
          puts ANSI.faint('-'*80)
        end
      end
    end
  end
end
