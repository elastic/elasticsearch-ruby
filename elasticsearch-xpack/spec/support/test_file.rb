require 'support/test_file/action'
require 'support/test_file/task_group'
require 'support/test_file/test'

module Elasticsearch

  module RestAPIYAMLTests

    # Class representing a single test file, containing a setup, teardown, and multiple tests.
    #
    # @since 6.1.1
    class TestFile

      attr_reader :skip_features
      attr_reader :name

      # Initialize a single test file.
      #
      # @example Create a test file object.
      #   TestFile.new(file_name)
      #
      # @param [ String ] file_name The name of the test file.
      # @param [ Array<Symbol> ] skip_features The names of features to skip.
      #
      # @since 6.1.0
      def initialize(file_name, skip_features = [])
        @name = file_name
        documents = YAML.load_stream(File.new(file_name))
        @test_definitions = documents.reject { |doc| doc['setup'] || doc['teardown'] }
        @setup = documents.find { |doc| doc['setup'] }
        @teardown = documents.find { |doc| doc['teardown'] }
        @skip_features = skip_features
      end

      # Get a list of tests in the test file.
      #
      # @example Get the list of tests
      #   test_file.tests
      #
      # @return [ Array<Test> ] A list of Test objects.
      #
      # @since 6.1.1
      def tests
        @test_definitions.collect do |test_definition|
          Test.new(self, test_definition)
        end
      end

      # Run the setup tasks defined for a single test file.
      #
      # @example Run the setup tasks.
      #   test_file.setup(client)
      #
      # @param [ Elasticsearch::Client ] client The client to use to perform the setup tasks.
      #
      # @return [ self ]
      #
      # @since 6.1.1
      def setup(client)
        return unless @setup
        actions = @setup['setup'].select { |action| action['do'] }.map { |action| Action.new(action['do']) }
        actions.each do |action|
          action.execute(client)
        end
        self
      end

      # Run the teardown tasks defined for a single test file.
      #
      # @example Run the teardown tasks.
      #   test_file.teardown(client)
      #
      # @param [ Elasticsearch::Client ] client The client to use to perform the teardown tasks.
      #
      # @return [ self ]
      #
      # @since 6.1.1
      def teardown(client)
        return unless @teardown
        actions = @teardown['teardown'].select { |action| action['do'] }.map { |action| Action.new(action['do']) }
        actions.each { |action| action.execute(client) }
        self
      end

      class << self

        # Prepare Elasticsearch for a single test file.
        # This method deletes indices, roles, datafeeds, etc.
        #
        # @since 6.1.1
        def prepare(client)
          clear_indices(client)
          clear_roles(client)
          clear_users(client)
          clear_privileges(client)
          clear_datafeeds(client)
          clear_jobs(client)
          clear_tasks(client)
          clear_machine_learning_indices(client)
          create_x_pack_rest_user(client)
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

        def clear_jobs(client)
          client.xpack.ml.close_job(job_id: '_all', force: true)
          client.xpack.ml.get_jobs['jobs'].each do |d|
            client.xpack.ml.delete_job(job_id: d['job_id'])
          end
        end

        def clear_tasks(client)
          tasks = client.tasks.get['nodes'].values.first['tasks'].values.select { |d| d['cancellable'] }.map { |d| "#{d['node']}:#{d['id']}" }
          tasks.each { |t| client.tasks.cancel task_id: t }
        end

        def clear_machine_learning_indices(client)
          client.indices.delete(index: '.ml-*', ignore: 404)
        end

        def clear_indices(client)
          indices = client.indices.get(index: '_all').keys.reject { |i| i.start_with?('.security') }
          client.indices.delete(index: indices, ignore: 404) unless indices.empty?
        end
      end
    end
  end
end