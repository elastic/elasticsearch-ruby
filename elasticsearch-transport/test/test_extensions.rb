require 'benchmark'
require 'ruby-prof'
require 'ansi/code'
require 'ansi/terminal'

module Elasticsearch
  module Test

    # Startup/shutdown support for test suites
    #
    # Example:
    #
    #     class MyTest < Test::Unit::TestCase
    #       extend IntegrationTestStartupShutdown
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
    module IntegrationTestStartupShutdown
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

    # Profiling support for tests with [ruby-prof](https://github.com/ruby-prof/ruby-prof)
    #
    # Example:
    #
    #     measure "divide numbers", count: 10_000 do
    #      assert_nothing_raised { 1/2 }
    #     end
    #
    # Will print out something like this along your test output:
    #
    #     ---------------------------------------------------------------------
    #     Context: My benchmark should divide numbers (10000x)
    #     mean: 0.01ms | avg: 0.01ms | max: 6.19ms
    #     ---------------------------------------------------------------------
    #     ...
    #     Total: 0.313283
    #
    #      %self      total      self      wait     child     calls  name
    #      25.38      0.313     0.079     0.000     0.234        1   <Object::MyTets>#__bind_1368638677_723101
    #      14.42      0.118     0.045     0.000     0.073    20000   <Class::Time>#now
    #      7.57       0.088     0.033     0.000     0.055    10000   Time#-
    #      ...
    #
    #     PASS (0:00:00.322) test: My benchmark should divide numbers (10000x).
    #
    #
    module ProfilingTestSupport

      # Profiles the passed block of code.
      #
      #     measure "divide numbers", count: 10_000 do
      #      assert_nothing_raised { 1/2 }
      #     end
      #
      # @todo Try to make progress bar not interfere with tests
      #
      def measure(name, options={}, &block)
        # require 'pry'; binding.pry
        ___          = '-'*ANSI::Terminal.terminal_width
        test_name    = self.name.split('::').last
        context_name = self.context(nil) {}.first.parent.name
        count        = Integer(ENV['COUNT'] || options[:count] || 1_000)
        ticks        = []
        # progress   = ANSI::Progressbar.new("#{name} (#{count}x)", count)

        should "#{name} (#{count}x)" do
          RubyProf.start

          count.times do
            ticks << Benchmark.realtime { self.instance_eval(&block) }
            # RubyProf.pause
            # progress.inc
            # RubyProf.resume
          end

          result = RubyProf.stop
          # progress.finish

          total = result.threads.reduce(0) { |total,info| total += info.total_time; total }
          mean  = (ticks.sort[(ticks.size/2).round-1])*1000
          avg   = (ticks.inject {|sum,el| sum += el; sum}.to_f/ticks.size)*1000
          max   = ticks.max*1000


          result.eliminate_methods!([/Integer#times|Benchmark.realtime|ANSI::Code#.*|ANSI::ProgressBar#.*/])
          printer = RubyProf::FlatPrinter.new(result)
          # printer = RubyProf::GraphPrinter.new(result)

          puts "\n",
               ___,
               'Context: ' + ANSI.bold(context_name) + ' should ' + ANSI.bold(name) + " (#{count}x)",
               "mean: #{sprintf('%.2f', mean)}ms | " +
               "avg: #{sprintf('%.2f',  avg)}ms | " +
               "max: #{sprintf('%.2f',  max)}ms",
               ___
          printer.print(STDOUT, {}) unless ENV['QUIET'] || options[:quiet]
        end
      end
    end

  end
end
