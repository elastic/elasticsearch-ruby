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
          logger = Logger.new($stdout)
          logger.error e
          logger.error "Filename : #{@name}"
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
        range.cover?(server_version)
      end

      def __parse_versions(versions)
        low = (['', nil].include? versions[0]) ? '0' : versions[0]
        high = (['', nil].include? versions[2]) ? '9999' : versions[2]
        [low, high]
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

        actions.each do |action|
          begin
            action.execute(client)
          rescue Elasticsearch::Transport::Transport::Errors::ServiceUnavailable => e
            # The action sometimes gets the cluster in a recovering state, so we
            # retry a few times and then raise an exception if it's still
            # happening
            count += 1
            raise e if count > 9

            redo
          rescue Elasticsearch::Transport::Transport::Errors::BadRequest,
                 Elasticsearch::Transport::Transport::Errors::Conflict => e
            error = JSON.parse(e.message.gsub(/\[[0-9]{3}\] /, ''))['error']['root_cause'].first
            count += 1

            logger = Logger.new($stdout)
            logger.error "#{error['type']}: #{error['reason']}"
            client.indices.delete(index: error['index']) if error['reason'] =~ /index \[.+\] already exists/
            raise e if count > 9

            sleep(1)
            redo
          end
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
          '.snapshot-blob-cache', '.deprecation-indexing-mappings', '.deprecation-indexing-settings'
        ].freeze

        # Wipe Cluster, based on PHP's implementation of ESRestTestCase.java:wipeCluster()
        # https://github.com/elastic/elasticsearch-php/blob/7.10/tests/Elasticsearch/Tests/Utility.php#L97
        def wipe_cluster(client)
          if xpack?
            clear_rollup_jobs(client)
            wait_for_pending_tasks(client)
            clear_sml_policies(client)
          end
          clear_snapshots_and_repositories(client)
          clear_datastreams(client) if xpack?
          clear_indices(client)
          if xpack?
            clear_datafeeds(client)
            clear_templates_xpack(client)
            clear_ml_jobs(client)
          else
            client.indices.delete_template(name: '*')
            client.indices.delete_index_template(name: '*')
            client.cluster.delete_component_template(name: '*')
          end
          clear_cluster_settings(client)
          return unless xpack?

          clear_ilm_policies(client)
          clear_auto_follow_patterns(client)
          clear_tasks(client)
          clear_indices(client)
          clear_transforms(client)
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

              count += 1 if task.include?(filter)
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
          # TODO
          # settings = client.cluster.get_settings
          # settings.each do |setting|
          # end
        end

        def clear_templates_xpack(client)
          templates = client.cat.templates(h: 'name').split("\n")

          templates.each do |template|
            next if xpack_template? template

            begin
              client.indices.delete_template(name: template)
            rescue Elasticsearch::Transport::Transport::Errors::NotFound => e
              if e.message.include?("index_template [#{template}] missing")
                client.indices.delete_index_template(name: template)
              end
            end
          end
          # Delete component template
          result = client.cluster.get_component_template

          result['component_templates'].each do |template|
            next if xpack_template? template['name']

            client.cluster.delete_component_template(name: template['name'])
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
          client.snapshot.get_repository(repository: '_all').keys.each do |repository|
            client.snapshot.get(repository: repository, snapshot: '_all')['snapshots'].each do |s|
              client.snapshot.delete(repository: repository, snapshot: s['snapshot'])
            end
            client.snapshot.delete_repository(repository: repository)
          end
        end

        def clear_transforms(client)
          client.data_frame.get_transform(transform_id: '*')['transforms'].each do |transform|
            client.data_frame.delete_transform(transform_id: transform[:id])
          end
        end

        def clear_datastreams(client)
          client.xpack.indices.delete_data_stream(name: '*', expand_wildcards: 'all')
          client.indices.delete_data_stream(name: '*', expand_wildcards: 'all')
        end

        def clear_indices(client)
          client.indices.delete(index: '*', expand_wildcards: 'all', ignore: 404)

          indices = client.indices.get(index: '_all', expand_wildcards: 'all').keys.reject do |i|
            i.start_with?('.security') || i.start_with?('.watches')
          end
          indices.each do |index|
            client.indices.delete_alias(index: index, name: '*', ignore: 404) unless index.start_with?('.ds')
            client.indices.delete(index: index, ignore: 404)
          end
        rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
          raise e unless e.message.include?('is the write index for data stream')

          error = JSON.parse(e.message.gsub(/\[[0-9]{3}\] /, ''))['error']['root_cause'].first
          logger = Logger.new($stdout)
          logger.error "#{error['type']}: #{error['reason']}"
        end
      end
    end
  end
end
