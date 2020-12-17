# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require_relative 'test_file/action'
require_relative 'test_file/test'
require_relative 'test_file/task_group'
require 'logger'

module Elasticsearch
  module RestAPIYAMLTests
    # Custom exception to raise when a test file needs to be skipped. This is
    # captured as soon as possible so the test runners can move on to the next test.
    class SkipTestsException < StandardError
    end

    # Class representing a single test file, containing a setup, teardown, and multiple tests.
    #
    # @since 6.2.0
    class TestFile
      attr_reader :features_to_skip, :name, :client
      LOGGER = Logger.new($stdout)

      # Initialize a single test file.
      #
      # @example Create a test file object.
      #   TestFile.new(file_name)
      #
      # @param [ String ] file_name The name of the test file.
      # @param [ Client] An instance of the client
      # @param [ Array<Symbol> ] skip_features The names of features to skip.
      #
      # @since 6.1.0
      def initialize(file_name, client, features_to_skip = [])
        @name = file_name
        @client = client
        begin
          documents = YAML.load_stream(File.new(file_name))
        rescue StandardError => e
          LOGGER.error e
          LOGGER.error "Filename : #{@name}"
        end
        @test_definitions = documents.reject { |doc| doc['setup'] || doc['teardown'] }
        @setup = documents.find { |doc| doc['setup'] }
        skip_entire_test_file? if @setup
        @teardown = documents.find { |doc| doc['teardown'] }
        @features_to_skip = REST_API_YAML_SKIP_FEATURES + features_to_skip
      end

      def skip_entire_test_file?
        @skip = @setup['setup']&.select { |a| a['skip'] }
        return false if @skip.empty?

        raise SkipTestsException if skip_version?(@client, @skip.first['skip'])
      end

      def skip_version?(client, skip_definition)
        return true if skip_definition['version'] == 'all'

        range_partition = /\s*-\s*/
        return unless (versions = skip_definition['version'])

        low, high = __parse_versions(versions.partition(range_partition))
        range = low..high
        begin
          server_version = client.info['version']['number']
        rescue
          warn('Could not determine Elasticsearch version when checking if test should be skipped.')
        end
        range.cover?(Gem::Version.new(server_version))
      end

      def __parse_versions(versions)
        versions = versions.split('-') if versions.is_a? String

        low = (['', nil].include? versions[0]) ? '0' : versions[0]
        high = (['', nil].include? versions[2]) ? '9999' : versions[2]
        [Gem::Version.new(low), Gem::Version.new(high)]
      end

      # Get a list of tests in the test file.
      #
      # @example Get the list of tests
      #   test_file.tests
      #
      # @return [ Array<Test> ] A list of Test objects.
      #
      # @since 6.2.0
      def tests
        @test_definitions.collect do |test_definition|
          Test.new(self, test_definition)
        end
      end

      # Run the setup tasks defined for a single test file.
      #
      # @example Run the setup tasks.
      #   test_file.setup
      #
      # @param [ Elasticsearch::Client ] client The client to use to perform the setup tasks.
      #
      # @return [ self ]
      #
      # @since 6.2.0
      def setup
        return unless @setup

        actions = @setup['setup'].select { |action| action['do'] }.map { |action| Action.new(action['do']) }
        count = 0
        loop do
          actions.delete_if do |action|
            begin
              action.execute(client)
              true
            rescue Elasticsearch::Transport::Transport::Errors::ServiceUnavailable => e
              # The action sometimes gets the cluster in a recovering state, so we
              # retry a few times and then raise an exception if it's still
              # happening
              count += 1
              raise e if count > 9

              false
            end
          end
          break if actions.empty?
        end

        self
      end

      # Run the teardown tasks defined for a single test file.
      #
      # @example Run the teardown tasks.
      #   test_file.teardown
      #
      # @param [ Elasticsearch::Client ] client The client to use to perform the teardown tasks.
      #
      # @return [ self ]
      #
      # @since 6.2.0
      def teardown
        return unless @teardown

        actions = @teardown['teardown'].select { |action| action['do'] }.map { |action| Action.new(action['do']) }
        actions.each { |action| action.execute(client) }
        self
      end

      class << self
        PRESERVE_ILM_POLICY_IDS = [
          'ilm-history-ilm-policy', 'slm-history-ilm-policy',
          'watch-history-ilm-policy', 'ml-size-based-ilm-policy', 'logs',
          'metrics'
        ].freeze

        XPACK_TEMPLATES = [
          '.watches', 'logstash-index-template', '.logstash-management',
          'security_audit_log', '.slm-history', '.async-search',
          'saml-service-provider', 'ilm-history', 'logs', 'logs-settings',
          'logs-mappings', 'metrics', 'metrics-settings', 'metrics-mappings',
          'synthetics', 'synthetics-settings', 'synthetics-mappings',
          '.snapshot-blob-cache', '.deprecation-indexing-template',
          '.deprecation-indexing-mappings', '.deprecation-indexing-settings'
        ].freeze

        # Wipe Cluster, based on PHP's implementation of ESRestTestCase.java:wipeCluster()
        # https://github.com/elastic/elasticsearch-php/blob/7.10/tests/Elasticsearch/Tests/Utility.php#L97
        def wipe_cluster(client)
          if xpack?
            clear_rollup_jobs(client)
            clear_sml_policies(client)
            wait_for_pending_tasks(client)
          end
          clear_snapshots_and_repositories(client)
          clear_datastreams(client) if xpack?
          clear_indices(client)
          if xpack?
            clear_templates_xpack(client)
            clear_datafeeds(client)
            clear_ml_jobs(client)
          else
            client.indices.delete_template(name: '*')
            client.indices.delete_index_template(name: '*')
            client.cluster.delete_component_template(name: '*')
          end
          clear_cluster_settings(client)
          return unless xpack?

          clear_ml_filters(client)
          clear_ilm_policies(client)
          clear_auto_follow_patterns(client)
          clear_tasks(client)
          clear_transforms(client)
          wait_for_cluster_tasks(client)
        end

        def xpack?
          ENV['TEST_SUITE'] == 'xpack'
        end

        def wait_for_pending_tasks(client)
          filter = 'xpack/rollup/job'
          loop do
            results = client.cat.tasks(detailed: true).split("\n")
            count = 0

            time = Time.now.to_i
            results.each do |task|
              next if task.empty?

              LOGGER.debug "Pending task: #{task}"
              count += 1 if task.include?(filter)
            end
            break unless count.positive? && Time.now.to_i < (time + 30)
          end
        end

        def wait_for_cluster_tasks(client)
          tasks_filter = ['delete-index', 'remove-data-stream', 'ilm-history', 'insert_order']
          time = Time.now.to_i
          count = 0

          loop do
            results = client.cluster.pending_tasks
            results['tasks'].each do |task|
              next if task.empty?

              LOGGER.debug "Pending cluster task: #{task}"
              tasks_filter.map do |filter|
                count += 1 if task['source'].include? filter
              end
            end
            break unless count.positive? && Time.now.to_i < (time + 30)
          end
        end

        def clear_sml_policies(client)
          policies = client.xpack.snapshot_lifecycle_management.get_lifecycle

          policies.each do |name, _|
            client.xpack.snapshot_lifecycle_management.delete_lifecycle(policy_id: name)
          end
        end

        def clear_ilm_policies(client)
          policies = client.xpack.ilm.get_lifecycle
          policies.each do |policy|
            client.xpack.ilm.delete_lifecycle(policy: policy[0]) unless PRESERVE_ILM_POLICY_IDS.include? policy[0]
          end
        end

        def clear_cluster_settings(client)
          settings = client.cluster.get_settings
          new_settings = []
          settings.each do |name, value|
            next unless !value.empty? && value.is_a?(Array)

            new_settings[name] = [] if new_settings[name].empty?
            value.each do |key, _v|
              new_settings[name]["#{key}.*"] = nil
            end
          end
          client.cluster.put_settings(body: new_settings) unless new_settings.empty?
        end

        def clear_templates_xpack(client)
          templates = client.cat.templates(h: 'name').split("\n")

          templates.each do |template|
            next if xpack_template? template

            begin
              client.indices.delete_template(name: template)
            rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
              if e.message.include?("index_template [#{template}] missing")
                client.indices.delete_index_template(name: template, ignore: 404)
              end
            end
          end
          # Delete component template
          result = client.cluster.get_component_template

          result['component_templates'].each do |template|
            next if xpack_template? template['name']

            client.cluster.delete_component_template(name: template['name'], ignore: 404)
          end
        end

        def xpack_template?(template)
          xpack_prefixes = ['.monitoring', '.watch', '.triggered-watches', '.data-frame', '.ml-', '.transform'].freeze
          xpack_prefixes.map { |a| return true if a.include? template }

          XPACK_TEMPLATES.include? template
        end

        def clear_auto_follow_patterns(client)
          patterns = client.cross_cluster_replication.get_auto_follow_pattern

          patterns['patterns'].each do |pattern|
            client.cross_cluster_replication.delete_auto_follow_pattern(name: pattern)
          end
        end

        private

        def create_x_pack_rest_user(client)
          client.xpack.security.put_user(username: 'x_pack_rest_user',
                                         body: { password: 'x-pack-test-password', roles: ['superuser'] })
        end

        def clear_roles(client)
          client.xpack.security.get_role.each do |role, _|
            begin; client.xpack.security.delete_role(name: role); rescue; end
          end
        end

        def clear_users(client)
          client.xpack.security.get_user.each do |user, _|
            begin; client.xpack.security.delete_user(username: user); rescue; end
          end
        end

        def clear_privileges(client)
          client.xpack.security.get_privileges.each do |privilege, _|
            begin; client.xpack.security.delete_privileges(name: privilege); rescue; end
          end
        end

        def clear_datafeeds(client)
          client.xpack.ml.stop_datafeed(datafeed_id: '_all', force: true)
          client.xpack.ml.get_datafeeds['datafeeds'].each do |d|
            client.xpack.ml.delete_datafeed(datafeed_id: d['datafeed_id'])
          end
        end

        def clear_ml_jobs(client)
          client.xpack.ml.close_job(job_id: '_all', force: true)
          client.xpack.ml.get_jobs['jobs'].each do |d|
            client.xpack.ml.delete_job(job_id: d['job_id'])
          end
        end

        def clear_rollup_jobs(client)
          client.xpack.rollup.get_jobs(id: '_all')['jobs'].each do |d|
            client.xpack.rollup.stop_job(id: d['config']['id'])
            client.xpack.rollup.delete_job(id: d['config']['id'])
          end
        end

        def clear_tasks(client)
          tasks = client.tasks.get['nodes'].values.first['tasks'].values.select do |d|
            d['cancellable']
          end.map do |d|
            "#{d['node']}:#{d['id']}"
          end
          tasks.each { |t| client.tasks.cancel task_id: t }
        end

        def clear_machine_learning_indices(client)
          client.indices.delete(index: '.ml-*', ignore: 404)
        end

        def clear_index_templates(client)
          client.indices.delete_template(name: '*')
          templates = client.indices.get_index_template
          templates['index_templates'].each do |template|
            client.indices.delete_index_template(name: template['name'])
          end
        end

        def clear_snapshots_and_repositories(client)
          return unless (repositories = client.snapshot.get_repository)

          repositories.each_key do |repository|

            client.snapshot.delete(repository: repository, snapshot: '*', ignore: 404) if(repositories[repository]['type'] == 'fs')

            client.snapshot.delete_repository(repository: repository, ignore: 404)
          end
        end

        def clear_transforms(client)
          client.transform.get_transform(transform_id: '*')['transforms'].each do |transform|
            client.transform.delete_transform(transform_id: transform[:id])
          end
        end

        def clear_datastreams(client)
          datastreams = client.xpack.indices.get_data_stream(name: '*', expand_wildcards: 'all')
          datastreams['data_streams'].each do |datastream|
            client.xpack.indices.delete_data_stream(name: datastream['name'], expand_wildcards: 'all')
          end
          begin
            client.indices.delete_data_stream(name: '*', expand_wildcards: 'all')
          rescue StandardError => e
            LOGGER.error "Caught exception attempting to delete data streams: #{e}"
            client.indices.delete_data_stream(name: '*')
          end
        end

        def clear_ml_filters(client)
          filters = client.xpack.ml.get_filters['filters']
          filters.each do |filter|
            client.xpack.ml.delete_filter(filter_id: filter['filter_id'])
          end
        end

        def clear_indices(client)
          client.indices.delete(index: '*,-.ds-ilm-history-*', expand_wildcards: 'open,closed,hidden', ignore: 404)
        end
      end
    end
  end
end
