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

module Elasticsearch
  module RestAPIYAMLTests
    module WipeCluster
      PRESERVE_ILM_POLICY_IDS = [
        'ilm-history-ilm-policy', 'slm-history-ilm-policy',
        'watch-history-ilm-policy', 'ml-size-based-ilm-policy', 'logs',
        'metrics'
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
        if platinum?
          clear_rollup_jobs(client)
          wait_for_pending_tasks(client)
          clear_sml_policies(client)
          wipe_searchable_snapshot_indices(client)
        end
        clear_snapshots_and_repositories(client)
        wipe_datastreams(client)
        clear_indices(client)
        if platinum?
          clear_templates_platinum(client)
          clear_datafeeds(client)
          clear_ml_jobs(client)
        else
          client.indices.delete_template(name: '*')
          client.indices.delete_index_template(name: '*')
          client.cluster.get_component_template['component_templates'].each do |template|
            next if platinum_template? template['name']

            client.cluster.delete_component_template(name: template['name'], ignore: 404)
          end
        end
        clear_cluster_settings(client)
        return unless platinum?

        clear_ml_filters(client)
        clear_ilm_policies(client)
        clear_auto_follow_patterns(client)
        clear_tasks(client)
        clear_transforms(client)
        delete_all_node_shutdown_metadata(client)
        wait_for_cluster_tasks(client)
      end

      class << self
        def platinum?
          ENV['TEST_SUITE'] == 'platinum'
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
          time = Time.now.to_i
          count = 0

          loop do
            results = client.cluster.pending_tasks
            results['tasks'].each do |task|
              next if task.empty?

              LOGGER.debug "Pending cluster task: #{task}"
              count += 1
            end
            break unless count.positive? && Time.now.to_i < (time + 30)
          end
        end

        def clear_sml_policies(client)
          policies = client.snapshot_lifecycle_management.get_lifecycle

          policies.each do |name, _|
            client.snapshot_lifecycle_management.delete_lifecycle(policy_id: name)
          end
        end

        def clear_ilm_policies(client)
          policies = client.ilm.get_lifecycle
          policies.each do |policy|
            client.ilm.delete_lifecycle(policy: policy[0]) unless PRESERVE_ILM_POLICY_IDS.include? policy[0]
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

        def clear_templates_platinum(client)
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
            end
          end
        end

        def platinum_template?(template)
          platinum_prefixes = ['.monitoring', '.watch', '.triggered-watches', '.data-frame', '.ml-', '.transform', 'data-streams-mappings'].freeze
          platinum_prefixes.map { |a| return true if a.include? template }

          PLATINUM_TEMPLATES.include? template
        end

        def clear_auto_follow_patterns(client)
          patterns = client.cross_cluster_replication.get_auto_follow_pattern

          patterns['patterns'].each do |pattern|
            client.cross_cluster_replication.delete_auto_follow_pattern(name: pattern)
          end
        end

        private

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

        def clear_datafeeds(client)
          client.ml.stop_datafeed(datafeed_id: '_all', force: true)
          client.ml.get_datafeeds['datafeeds'].each do |d|
            client.ml.delete_datafeed(datafeed_id: d['datafeed_id'])
          end
        end

        def clear_ml_jobs(client)
          client.ml.close_job(job_id: '_all', force: true)
          client.ml.get_jobs['jobs'].each do |d|
            client.ml.delete_job(job_id: d['job_id'])
          end
        end

        def clear_rollup_jobs(client)
          client.rollup.get_jobs(id: '_all')['jobs'].each do |d|
            client.rollup.stop_job(id: d['config']['id'])
            client.rollup.delete_job(id: d['config']['id'])
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
          return unless (repositories = client.snapshot.get_repository(repository: '_all'))

          repositories.each_key do |repository|
            client.snapshot.delete(repository: repository, snapshot: '*', ignore: 404) if repositories[repository]['type'] == 'fs'
            begin
              response = client.perform_request('DELETE', "_snapshot/#{repository}", ignore: [500, 404])
              client.snapshot.delete_repository(repository: repository, ignore: 404)
            rescue Elastic::Transport::Transport::Errors::InternalServerError => e
              regexp = /indices that use the repository: \[docs\/([a-zA-Z0-9]+)/
              raise e unless response.body['error']['root_cause'].first['reason'].match(regexp)

              # Try again after clearing indices if we get a 500 error from delete repository
              clear_indices(client)
              client.snapshot.delete_repository(repository: repository, ignore: 404)
            end
          end
        end

        def clear_transforms(client)
          client.transform.get_transform(transform_id: '*')['transforms'].each do |transform|
            client.transform.delete_transform(transform_id: transform[:id])
          end
        end

        def wipe_datastreams(client)
          datastreams = client.indices.get_data_stream(name: '*', expand_wildcards: 'all')
          datastreams['data_streams'].each do |datastream|
            client.indices.delete_data_stream(name: datastream['name'], expand_wildcards: 'all')
          end
          begin
            client.indices.delete_data_stream(name: '*', expand_wildcards: 'all')
          rescue StandardError => e
            LOGGER.error "Caught exception attempting to delete data streams: #{e}"
            client.indices.delete_data_stream(name: '*')
          end
        end

        def clear_ml_filters(client)
          filters = client.ml.get_filters['filters']
          filters.each do |filter|
            client.ml.delete_filter(filter_id: filter['filter_id'])
          end
        end

        def clear_indices(client)
          client.indices.delete(index: '*,-.ds-ilm-history-*', expand_wildcards: 'open,closed,hidden', ignore: 404)
        rescue Elasticsearch::Transport::Transport::Errors::BadRequest => e
          LOGGER.info "Exception trying to delete index #{e}"
        end

        def wipe_searchable_snapshot_indices(client)
          indices = client.cluster.state(metric: 'metadata', filter_path: 'metadata.indices.*.settings.index.store.snapshot')
          return if indices.dig('metadata', 'indices')

          indices.each do |index|
            client.indices.delete(index: index, ignore: 404)
          end
        end

        def delete_all_node_shutdown_metadata(client)
          nodes = client.shutdown.get_node
          return if nodes['_nodes'] && nodes['cluster_name'] || nodes&.[]("nodes").empty?

          nodes.each do |node|
            client.shutdown.delete_node(node['node_id'])
          end
        end
      end
    end
  end
end
