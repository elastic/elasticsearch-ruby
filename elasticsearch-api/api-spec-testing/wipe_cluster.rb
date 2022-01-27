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
include Elasticsearch::RestAPIYAMLTests::Logging

module Elasticsearch
  module RestAPIYAMLTests
    module WipeCluster
      PRESERVE_ILM_POLICY_IDS = [
        'ilm-history-ilm-policy', 'slm-history-ilm-policy', 'watch-history-ilm-policy',
        'ml-size-based-ilm-policy', 'logs', 'metrics', 'synthetics', '7-days-default',
        '30-days-default', '90-days-default', '180-days-default', '365-days-default',
        '.fleet-actions-results-ilm-policy', '.deprecation-indexing-ilm-policy',
        'watch-history-ilm-policy-16', '.monitoring-8-ilm-policy'
      ].freeze

      PLATINUM_TEMPLATES = [
        '.watches', 'logstash-index-template', '.logstash-management',
        'security_audit_log', '.slm-history', '.async-search',
        'saml-service-provider', 'ilm-history', 'logs', 'logs-settings',
        'logs-mappings', 'metrics', 'metrics-settings', 'metrics-mappings',
        'synthetics', 'synthetics-settings', 'synthetics-mappings',
        '.snapshot-blob-cache', '.deprecation-indexing-template',
        '.deprecation-indexing-mappings', '.deprecation-indexing-settings',
        'security-index-template', 'data-streams-mappings'
      ].freeze

      # Wipe Cluster, based on PHP's implementation of ESRestTestCase.java:wipeCluster()
      # https://github.com/elastic/elasticsearch-php/blob/7.10/tests/Elasticsearch/Tests/Utility.php#L97
      def self.run(client)
        ensure_no_initializing_shards(client)
        wipe_cluster(client)
        wait_for_cluster_tasks(client)
        check_for_unexpectedly_recreated_objects(client)
      end

      class << self
        private

        def wipe_cluster(client)
          read_plugins(client)
          if @has_rollups
            wipe_rollup_jobs(client)
            wait_for_pending_rollup_tasks(client)
          end
          delete_all_slm_policies(client)
          wipe_searchable_snapshot_indices(client) if @has_xpack
          wipe_snapshots(client)
          wipe_datastreams(client)
          wipe_all_indices(client)
          if platinum?
            wipe_templates_for_xpack(client)
          else
            wipe_all_templates(client)
          end
          wipe_cluster_settings(client)
          if platinum?
            clear_ml_jobs(client)
            clear_datafeeds(client)
          end
          delete_all_ilm_policies(client) if @has_ilm
          delete_all_follow_patterns(client) if @has_ccr
          delete_all_node_shutdown_metadata(client)
          # clear_ml_filters(client)
          # clear_tasks(client)
          # clear_transforms(client)
        end

        def ensure_no_initializing_shards(client)
          client.cluster.health(wait_for_no_initializing_shards: true, timeout: '70s', level: 'shards')
        end

        def check_for_unexpectedly_recreated_objects(client)
          unexpected_ilm_policies = client.index_lifecycle_management.get_lifecycle
          unexpected_ilm_policies.reject! { |k, _| PRESERVE_ILM_POLICY_IDS.include? k }
          unless unexpected_ilm_policies.empty?
            logger.info(
              "Expected no ILM policies after deletions, but found #{unexpected_ilm_policies.keys.join(',')}"
            )
          end
          return unless platinum?

          templates = client.indices.get_index_template
          unexpected_templates = templates['index_templates'].reject do |t|
            # reject platinum templates
            PLATINUM_TEMPLATES.include? t['name']
          end.map { |t| t['name'] } # only keep the names
          legacy_templates = client.indices.get_template
          unexpected_templates << legacy_templates.keys.reject { |t| PLATINUM_TEMPLATES.include? t }

          unless unexpected_templates.empty?
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
          loop do
            results = client.cat.tasks(detailed: true).split("\n")
            count = 0

            time = Time.now.to_i
            results.each do |task|
              next if task.empty?

              logger.debug("Pending task: #{task}")
              count += 1 if task.include?(filter)
            end
            break unless count.positive? && Time.now.to_i < (time + 30)
          end
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
              if repositories[repository]['type'] == 'fs'
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

        def wipe_templates_for_xpack(client)
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
            next if platinum_template? name

            begin
              client.indices.delete_template(name: name)
            rescue StandardError => e
              logger.info("Unable to remove index template #{name}")
            end
          end
        end

        def wipe_all_templates(client)
          client.indices.delete_template(name: '*')
          begin
            client.indices.delete_index_template(name: '*')
            client.cluster.delete_component_template(name: '*')
          rescue StandardError => e
            logger.info('Using a version of ES that doesn\'t support index templates v2 yet, so it\'s safe to ignore')
          end
        end

        def platinum_template?(template)
          platinum_prefixes = ['.monitoring', '.watch', '.triggered-watches', '.data-frame', '.ml-', '.transform', 'data-streams-mappings'].freeze
          platinum_prefixes.map { |a| return true if a.include? template }

          PLATINUM_TEMPLATES.include? template
        end

        def wait_for_cluster_tasks(client)
          time = Time.now.to_i
          count = 0

          loop do
            results = client.cluster.pending_tasks
            results['tasks'].each do |task|
              next if task.empty?

              logger.debug "Pending cluster task: #{task}"
              count += 1
            end
            break unless count.positive? && Time.now.to_i < (time + 30)
          end
        end

        def delete_all_ilm_policies(client)
          policies = client.ilm.get_lifecycle
          policies.each do |policy|
            client.ilm.delete_lifecycle(policy: policy[0]) unless PRESERVE_ILM_POLICY_IDS.include? policy[0]
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

        def create_xpack_rest_user(client)
          client.security.put_user(
            username: 'x_pack_rest_user',
            body: { password: 'x-pack-test-password', roles: ['superuser'] }
          )
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
            client.transform.delete_transform(transform_id: transform[:id])
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
          return unless nodes

          nodes['nodes'].each do |node|
            client.shutdown.delete_node(node['node_id'])
          end
        end
      end
    end
  end
end
