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

require_relative 'logging'
require_relative 'custom_cleanup'
include Elasticsearch::RestAPIYAMLTests::Logging

module Elasticsearch
  module RestAPIYAMLTests
    module WipeCluster
      PRESERVE_ILM_POLICY_IDS = [
        'ilm-history-ilm-policy', 'slm-history-ilm-policy', 'watch-history-ilm-policy',
        'watch-history-ilm-policy-16', 'ml-size-based-ilm-policy', 'logs', 'metrics', 'profiling',
        'synthetics', '7-days-default', '30-days-default', '90-days-default', '180-days-default',
        '365-days-default', '.fleet-files-ilm-policy', '.fleet-file-data-ilm-policy',
        '.fleet-actions-results-ilm-policy', '.fleet-file-fromhost-data-ilm-policy',
        '.fleet-file-fromhost-meta-ilm-policy', '.fleet-file-tohost-data-ilm-policy',
        '.fleet-file-tohost-meta-ilm-policy', '.deprecation-indexing-ilm-policy',
        '.monitoring-8-ilm-policy', 'behavioral_analytics-events-default_policy'
      ].freeze

      PLATINUM_TEMPLATES = [
        '.watches', 'logstash-index-template', '.logstash-management',
        'security_audit_log', '.slm-history', '.async-search',
        'saml-service-provider', 'ilm-history', 'logs', 'logs-settings',
        'logs-mappings', 'metrics', 'metrics-settings', 'metrics-mappings',
        'synthetics', 'synthetics-settings', 'synthetics-mappings',
        '.snapshot-blob-cache', '.deprecation-indexing-template',
        '.deprecation-indexing-mappings', '.deprecation-indexing-settings',
        'security-index-template', 'data-streams-mappings', 'search-acl-filter',
        '.kibana-reporting'
      ].freeze

      # Wipe Cluster, based on PHP's implementation of ESRestTestCase.java:wipeCluster()
      # https://github.com/elastic/elasticsearch-php/blob/7.10/tests/Elasticsearch/Tests/Utility.php#L97
      def self.run(client)
        ensure_no_initializing_shards(client)
        wipe_cluster(client)
        wait_for_cluster_tasks(client)
        check_for_unexpectedly_recreated_objects(client)
      end

      def self.create_xpack_rest_user(client)
        client.security.put_user(
          username: 'x_pack_rest_user',
          body: { password: 'x-pack-test-password', roles: ['superuser'] }
        )
      end

      def self.create_enterprise_search_users(client)
        client.security.put_role(
          name: 'entuser',
          body: {
            cluster: [
              'post_behavioral_analytics_event',
              'manage_api_key',
              'read_connector_secrets',
              'write_connector_secrets'
            ],
            indices: [
              {
                names: [
                  'test-index1',
                  'test-search-application',
                  'test-search-application-1',
                  'test-search-application-with-aggs',
                  'test-search-application-with-list',
                  'test-search-application-with-list-invalid',
                  '.elastic-connectors-v1',
                  '.elastic-connectors-sync-jobs-v1'
                ],
                privileges: ['read']
              }
            ]
          }
        )
        client.security.put_role(
          name: 'unprivileged',
          body: {
            indices: [
              {
                names: ['test-*', 'another-test-search-application'],
                privileges: ['manage', 'write', 'read']
              }
            ]
          }
        )

        client.security.put_user(
          username: 'entsearch-user',
          body: { password: 'entsearch-user-password', roles: ['entuser'] }
        )
        client.security.put_user(
          username: 'entsearch-unprivileged',
          body: { password: 'entsearch-unprivileged-password', roles: ['privileged'] }
        )
      end

      class << self
        private

        def wipe_cluster(client)
          read_plugins(client)
          if @has_rollups
            wipe_rollup_jobs(client)
            # wait_for_pending_rollup_tasks(client)
          end
          delete_all_slm_policies(client)
          wipe_searchable_snapshot_indices(client) if @has_xpack
          wipe_snapshots(client)
          wipe_datastreams(client)
          wipe_all_indices(client)
          wipe_all_templates(client)
          wipe_cluster_settings(client)
          if platinum?
            clear_ml_jobs(client)
            clear_datafeeds(client)
            delete_data_frame_analytics(client)
            clear_ml_filters(client)
            delete_trained_models(client)
          end
          delete_all_ilm_policies(client) if @has_ilm
          delete_all_follow_patterns(client) if @has_ccr
          delete_all_node_shutdown_metadata(client)
          clear_tasks(client)
          clear_transforms(client)

          # Custom implementations
          CustomCleanup::wipe_calendars(client)
        end

        def ensure_no_initializing_shards(client)
          client.cluster.health(wait_for_no_initializing_shards: true, timeout: '70s', level: 'shards')
        end

        def check_for_unexpectedly_recreated_objects(client)
          unexpected_ilm_policies = client.index_lifecycle_management.get_lifecycle
          unexpected_ilm_policies.reject! { |k, _| preserve_policy?(k) }
          unless unexpected_ilm_policies.empty?
            logger.info(
              "Expected no ILM policies after deletions, but found #{unexpected_ilm_policies.keys.join(',')}"
            )
          end
          return unless platinum?

          templates = client.indices.get_index_template
          unexpected_templates = templates['index_templates'].reject do |t|
            # reject platinum templates
            platinum_template?(t['name'])
          end.map { |t| t['name'] } # only keep the names
          legacy_templates = client.indices.get_template
          unexpected_templates << legacy_templates.keys.reject { |t| platinum_template?(t) }

          unless unexpected_templates.reject(&:empty?).empty?
            logger.info(
              "Expected no templates after deletions, but found #{unexpected_templates.join(',')}"
            )
          end
        end

        def platinum?
          ENV['TEST_SUITE'] == 'platinum'
        end

        def read_plugins(client)
          response = client.perform_request('GET', '_nodes/plugins').body

          response['nodes'].each do |node|
            node[1]['modules'].each do |mod|
              @has_xpack = true if mod['name'].include?('x-pack')
              @has_ilm = true if mod['name'].include?('x-pack-ilm')
              @has_rollups = true if mod['name'].include?('x-pack-rollup')
              @has_ccr = true if mod['name'].include?('x-pack-ccr')
              @has_shutdown = true if mod['name'].include?('x-pack-shutdown')
            end
          end
        end

        def wipe_rollup_jobs(client)
          client.rollup.get_jobs(id: '_all')['jobs'].each do |d|
            client.rollup.stop_job(id: d['config']['id'], wait_for_completion: true, timeout: '10s', ignore: 404)
            client.rollup.delete_job(id: d['config']['id'], ignore: 404)
          end
        end

        def wait_for_pending_rollup_tasks(client)
          filter = 'xpack/rollup/job'
          start_time = Time.now.to_i
          count = 0
          loop do
            results = client.cat.tasks(detailed: true).split("\n")

            results.each do |task|
              next if task.empty? || skippable_task?(task) || task.include?(filter)

              count += 1
            end
            break unless count.positive? && Time.now.to_i < (start_time + 1)
          end
          logger.debug("Waited for #{count} pending rollup tasks for #{Time.now.to_i - start_time}s.") if count.positive?
        end

        def delete_all_slm_policies(client)
          policies = client.snapshot_lifecycle_management.get_lifecycle

          policies.each do |name, _|
            client.snapshot_lifecycle_management.delete_lifecycle(policy_id: name)
          end
        end

        def wipe_searchable_snapshot_indices(client)
          indices = client.cluster.state(metric: 'metadata', filter_path: 'metadata.indices.*.settings.index.store.snapshot')
          return unless indices.dig('metadata', 'indices')

          indices['metadata']['indices'].each do |index|
            index_name = if index.is_a?(Array)
                           index[0]
                         elsif index.is_a?(Hash)
                           index.keys.first
                         end
            client.indices.delete(index: index_name, ignore: 404)
          end
        end

        def wipe_snapshots(client)
          # Repeatedly delete the snapshots until there aren't any
          loop do
            repositories = client.snapshot.get_repository(repository: '_all')
            break if repositories.empty?

            repositories.each_key do |repository|
              if ['fs', 'source'].include? repositories[repository]['type']
                response = client.snapshot.get(repository: repository, snapshot: '_all', ignore_unavailable: true)
                response['snapshots'].each do |snapshot|
                  if snapshot['state'] != 'SUCCESS'
                    logger.debug("Found snapshot that did not succeed #{snapshot}")
                  end
                  client.snapshot.delete(repository: repository, snapshot: snapshot['snapshot'], ignore: 404)
                end
              end
              client.snapshot.delete_repository(repository: repository, ignore: 404)
            end
          end
        end

        def wipe_datastreams(client)
          begin
            client.indices.delete_data_stream(name: '*', expand_wildcards: 'all')
          rescue StandardError => e
            logger.error "Caught exception attempting to delete data streams: #{e}"
            client.indices.delete_data_stream(name: '*')
          end
        end

        def wipe_all_indices(client)
          client.indices.delete(index: '*,-.ds-ilm-history-*', expand_wildcards: 'open,closed,hidden', ignore: 404)
        end

        def wipe_all_templates(client)
          templates = client.indices.get_index_template

          templates['index_templates'].each do |template|
            next if platinum_template? template['name']

            begin
              client.indices.delete_index_template(name: template['name'], ignore: 404)
            end
          end
          # Delete component template
          result = client.cluster.get_component_template

          result['component_templates'].each do |template|
            next if platinum_template? template['name']

            client.cluster.delete_component_template(name: template['name'], ignore: 404)
          end

          # Always check for legacy templates
          templates = client.indices.get_template
          templates.each do |name, _|
            next if platinum_template?(name)

            begin
              client.indices.delete_template(name: name)
            rescue StandardError => e
              logger.info("Unable to remove index template #{name}")
            end
          end
        end

        def platinum_template?(template)
          return true if template.include?('@')

          platinum_prefixes = [
            '.monitoring', '.watch', '.triggered-watches', '.data-frame', '.ml-',
            '.transform', '.deprecation', 'data-streams-mappings', '.fleet',
            'behavioral_analytics-', 'profiling', 'elastic-connectors', 'ilm-history', '.slm-history'
          ].freeze
          return true if template.start_with?(*platinum_prefixes)

          PLATINUM_TEMPLATES.include? template
        end

        def preserve_policy?(policy)
          PRESERVE_ILM_POLICY_IDS.include?(policy) || policy.include?('@')
        end

        def wait_for_cluster_tasks(client)
          start_time = Time.now.to_i
          count = 0
          loop do
            results = client.cluster.pending_tasks
            results['tasks'].each do |task|
              next if task.empty? || skippable_task?(task)

              count += 1
            end
            break unless count.positive? && Time.now.to_i < (start_time + 5)
          end
          logger.debug("Waited for #{count} pending cluster tasks for #{Time.now.to_i - start_time}s.") if count.positive?
        end

        def skippable_task?(task)
          names = ['health-node', 'cluster:monitor/tasks/lists', 'create-index-template-v2',
                   'remove-component-template', 'create persistent task',
                   'finish persistent task']
          if task.is_a?(String)
            names.select { |n| task.match? n }.any?
          elsif task.is_a?(Hash)
            names.select { |n| task['source'].match? n }.any?
          end
        end

        def delete_all_ilm_policies(client)
          policies = client.ilm.get_lifecycle
          policies.each do |policy|
            client.ilm.delete_lifecycle(policy: policy[0]) unless preserve_policy?(policy[0])
          end
        end

        def wipe_cluster_settings(client)
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

        def delete_all_follow_patterns(client)
          patterns = client.cross_cluster_replication.get_auto_follow_pattern

          patterns['patterns'].each do |pattern|
            client.cross_cluster_replication.delete_auto_follow_pattern(name: pattern)
          end
        end

        def clear_roles(client)
          client.security.get_role.each do |role, _|
            begin; client.security.delete_role(name: role); rescue; end
          end
        end

        def clear_users(client)
          client.security.get_user.each do |user, _|
            begin; client.security.delete_user(username: user); rescue; end
          end
        end

        def clear_privileges(client)
          client.security.get_privileges.each do |privilege, _|
            begin; client.security.delete_privileges(name: privilege); rescue; end
          end
        end

        def clear_ml_jobs(client)
          client.ml.close_job(job_id: '_all', force: true)
          client.ml.get_jobs['jobs'].each do |d|
            client.ml.delete_job(job_id: d['job_id'])
          end
        end

        def clear_datafeeds(client)
          client.ml.stop_datafeed(datafeed_id: '_all', force: true)
          client.ml.get_datafeeds['datafeeds'].each do |d|
            client.ml.delete_datafeed(datafeed_id: d['datafeed_id'])
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

        def clear_transforms(client)
          client.transform.get_transform(transform_id: '*')['transforms'].each do |transform|
            client.transform.delete_transform(transform_id: transform['id'])
          end
        end

        def clear_ml_filters(client)
          filters = client.ml.get_filters['filters']
          filters.each do |filter|
            client.ml.delete_filter(filter_id: filter['filter_id'])
          end
        end

        def delete_all_node_shutdown_metadata(client)
          nodes = client.shutdown.get_node
          return unless nodes['nodes']

          nodes['nodes'].each do |node|
            client.shutdown.delete_node(node['node_id'])
          end
        end

        def delete_data_frame_analytics(client)
          dfs = client.ml.get_data_frame_analytics
          return unless dfs['data_frame_analytics']

          dfs['data_frame_analytics'].each do |df|
            client.ml.delete_data_frame_analytics(id: df['id'], force: true)
          end
        end

        def delete_trained_models(client)
          models = client.ml.get_trained_models
          return unless models['trained_model_configs']

          models['trained_model_configs'].each do |model|
            client.ml.delete_trained_model(model_id: model['model_id'], force: true, ignore: 400)
          end
        end
      end
    end
  end
end
