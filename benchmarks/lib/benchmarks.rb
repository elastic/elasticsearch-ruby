# Licensed to Elasticsearch B.V. under one or more agreements.
# Elasticsearch B.V. licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information.

require "ostruct"
require "time"
require "rbconfig"

require "ansi/core"
require "elasticsearch"

##
# Module Benchmarks contains components for end-to-end benchmarking of the Ruby client for Elasticsearch.
#
module Benchmarks
	DEFAULT_WARMUPS = 0
	DEFAULT_REPETITIONS = 1_000
	DEFAULT_OPERATIONS = 1

	##
	# Represents the benchmarking action.
	#
	class Action
		attr_reader :action, :category, :warmups, :repetitions, :operations, :setup, :measure

    # @param action      [String] The name of the measured action
    # @param category    [String] The category of the measured action
    # @param warmups     [Number] The number of warmup runs
    # @param repetitions [Number] The number of repetitions
    # @param operations  [Number] The number of operations in a single repetition
    # @param setup       [Block] The operation setup
    # @param measure     [Block] The measured operation
		def initialize(action:, category:, warmups:, repetitions:, operations:, setup:, measure:)
      raise ArgumentError.new("Required parameter [action] empty")   if action.empty?
      raise ArgumentError.new("Required parameter [category] empty") if category.empty?

			@action = action
			@category = category
			@warmups = warmups         || DEFAULT_WARMUPS
			@repetitions = repetitions || DEFAULT_REPETITIONS
			@operations = operations   || DEFAULT_OPERATIONS
			@setup = setup
			@measure = measure
		end
	end

	##
	# Registers an action for benchmarking.
	#
  # @option arguments [String] :action The name of the measured action
  # @option arguments [String] :category The category of the measured action
  # @option arguments [Number] :warmups The number of warmup runs
  # @option arguments [Number] :repetitions The number of repetitions
  # @option arguments [Number] :operations The number of operations in a single repetition
  # @option arguments [Block]  :setup The operation setup
  # @option arguments [Block]  :measure The measured operation
	#
	def self.register(arguments = {})
		self.actions << Action.new(
			action: arguments[:action],
			category: arguments[:category],
			warmups: arguments[:warmups],
			repetitions: arguments[:repetitions],
			operations: arguments[:operations],
			setup: arguments[:setup],
			measure: arguments[:measure]
		)
	end

	##
	# Set data path for benchmarks.
	#
	# @param path [Pathname,String]
	#
	def self.data_path=(path)
		@data_path = Pathname(path)
	end

	##
	# Return data path for benchmarks.
	#
	# @return [Pathname]
	#
	def self.data_path
		@data_path
	end

	##
	# Returns the registered actions.
	#
	# @return [Array]
	#
	def self.actions
		@actions ||= []
	end

	##
  # Module Runner contains components for running the benchmarks.
  #
  module Runner
    ##
    # Stats represents the measured statistics.
    #
    class Stats < OpenStruct; end

    ##
    # Errors contain error class for runner operations.
    #
    module Errors
      ##
      # ReportError represents an exception ocurring during reporting the results.
      #
      class ReportError < StandardError; end

      ##
      # SetupError represents an exception occuring during operation setup.
      #
      class SetupError < StandardError; end

      ##
      # WarmupError represents an exception occuring during operation warmup.
      #
      class WarmupError < StandardError; end
    end

    ##
    # The bulk size for reporting results.
    #
    BULK_BATCH_SIZE = 1000

    ##
    # The index name for reporting results.
    #
    INDEX_NAME="metrics-intake-#{Time.now.strftime("%Y-%m")}"

    ##
    # Runner represents a benchmarking runner.
    #
    # It is initialized with two Elasticsearch clients, one for running the benchmarks,
    # another one for reporting the results.
    #
    # Use the {#measure} method for adding a block which is executed and measured.
    #
    class Runner
      attr_reader :stats, :runner_client, :report_client, :warmups, :repetitions, :operations

      ##
      # @param runner_client [Elasticsearch::Client] The client for executing the measured operations.
      # @param report_client [Elasticsearch::Client] The client for storing the results.
      #
      def initialize(build_id:, category:, environment:, runner_client:, report_client:, target:, runner:)
        raise ArgumentError.new("Required parameter [build_id] empty") if build_id.empty?
        raise ArgumentError.new("Required parameter [environment] empty") if environment.empty?

        @action = ''
        @stats = []
        @warmups = 0
        @repetitions = 0
        @operations = 0

        @build_id = build_id
        @category = category
        @environment = environment
        @runner_client = runner_client
        @report_client = report_client
        @target_config = target
        @runner_config = runner
      end

      ##
      # Executes the measured block, capturing statistics, and reports the results.
      #
      # @return [Boolean]
      # @raise [Errors::ReportError]
      #
      def run!
        @stats = []

        # Run setup code
        begin
          @setup.arity < 1 ? self.instance_eval(&@setup) : @setup.call(self) if @setup
        rescue StandardError => e
          raise Errors::SetupError.new(e.inspect)
        end

        # Run warmups
        begin
          @warmups.times do |n|
            @measure.arity < 1 ? self.instance_eval(&@measure) : @measure.call(n, self) if @measure
          end
        rescue StandardError => e
          raise Errors::WarmupError.new(e.inspect)
        end

        # Run measured repetitions
        #
        # Cf. https://blog.dnsimple.com/2018/03/elapsed-time-with-ruby-the-right-way/
        @repetitions.times do |n|
          stat = Stats.new(start: Time.now.utc)
          start = Process.clock_gettime(Process::CLOCK_MONOTONIC)
          begin
            result = @measure.arity < 1 ? result = self.instance_eval(&@measure) : result = @measure.call(n, self) if @measure
            if result == false
              stat.outcome = "failure"
            else
              stat.outcome = "success"
            end
          rescue StandardError => e
            stat.outcome = "failure"
          ensure
            stat.duration = ((Process.clock_gettime(Process::CLOCK_MONOTONIC)-start) * 1e+9 ).to_i
            @stats << stat
          end
        end

        # Report results
        begin
          __report
        rescue StandardError => e
          puts "ERROR: #{e.inspect}"
          return false
        end

        return true
      end

      ##
      # Configure a setup for the measure operation.
      #
      # @return [self]
      #
      def setup &block
        @setup = block
        return self
      end

      ##
      # Configure the measure operation.
      #
      # @param action      [String] A human-readable name of the operation.
      # @param category    [String] The operation category.
      # @param warmups     [Number] The number of warmups.
      # @param repetitions [Number] The number of repetitions.
      # @param operations  [Number] The number of operations in a single repetition.
      #
      # @return [self]
      #
      def measure(action:, category:, warmups:, repetitions:, operations:, &block)
        raise ArgumentError.new("Required parameter [action] empty") if action.empty?
        raise ArgumentError.new("Required parameter [category] empty") if category.empty?
        raise ArgumentError.new("Required parameter [repetitions] not a number") unless repetitions.is_a? Numeric
        raise ArgumentError.new("Required parameter [operations] not a number") unless operations.is_a? Numeric

        @action = action
        @category = category
        @warmups = warmups
        @repetitions = repetitions
        @operations = operations
        @measure = block
        return self
      end

      ##
      # Stores the result in the reporting cluster.
      #
      # @api private
      #
      def __report
        @stats.each_slice(BULK_BATCH_SIZE) do |slice|
          payload = slice.map do |s|
            { index: {
                data: {
                  :'@timestamp' => s.start.iso8601,
                  labels: {
                    build_id: @build_id,
                    client: 'elasticsearch-ruby',
                    environment: @environment.to_s
                  },
                  tags: ['bench', 'elasticsearch-ruby'],
                  event: {
                    action: @action,
                    duration: s.duration,
                    outcome: s.outcome
                  },
                  benchmark: {
                    build_id: @build_id,
                    environment: @environment.to_s,
                    category: @category.to_s,
                    repetitions: @repetitions,
                    operations: @operations,
                    runner: {
                      service: @runner_config[:service].merge({
                        type: 'client',
                        name: 'elasticsearch-ruby',
                        version: Elasticsearch::VERSION
                      }),
                      runtime: {
                        name: 'ruby', version: RbConfig::CONFIG['ruby_version']
                      },
                      os: {
                        family: RbConfig::CONFIG['host_os'].split('_').first[/[a-z]+/i].downcase
                      }
                    },
                    target: @target_config
                  }
                }
              }
            }
          end

          begin

          rescue Elasticsearch::Transport::Transport::Error => e
            puts "ERROR: #{e.inspect}"
            raise e
          end

          response = @report_client.bulk index: INDEX_NAME, body: payload
          if response['errors'] || response['items'].any? { |i| i.values.first['status'] > 201 }
            raise Errors::ReportError.new("Error saving benchmark results to report cluster")
          end
        end
      end
    end
  end
end
