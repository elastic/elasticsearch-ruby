# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/test_file"
require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/rspec_matchers"
include Elasticsearch::RestAPIYAMLTests

TRANSPORT_OPTIONS = {}
PROJECT_PATH = File.join(File.dirname(__FILE__), '..', '..')

if hosts = ELASTICSEARCH_URL
  split_hosts = hosts.split(',').map do |host|
    /(http\:\/\/)?\S+/.match(host)
  end
  uri = URI.parse(split_hosts.first[0])
  TEST_HOST = uri.host
  TEST_PORT = uri.port
else
  TEST_HOST, TEST_PORT = 'localhost', '9200'
end

if defined?(TEST_HOST) && defined?(TEST_PORT)
  URL = "http://#{TEST_HOST}:#{TEST_PORT}"

  ADMIN_CLIENT = Elasticsearch::Client.new(host: URL, transport_options: TRANSPORT_OPTIONS)

  if ENV['QUIET'] == 'true'
    DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL, transport_options: TRANSPORT_OPTIONS)
  else
    DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL,
                                               transport_options: TRANSPORT_OPTIONS,
                                               tracer: Logger.new($stdout))
  end
end


YAML_FILES_DIRECTORY = "#{File.expand_path(File.dirname('..'), '..')}" +
    "/tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/test"

SINGLE_TEST = if ENV['SINGLE_TEST'] && !ENV['SINGLE_TEST'].empty?
                ["#{File.expand_path(File.dirname('..'), '..')}" +
                     "/tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/test/#{ENV['SINGLE_TEST']}"]
              end

skipped_tests = []

# Response from Elasticsearch is just a String, so it's not possible to compare using headers.
skipped_tests << { file:        'cat.aliases/20_headers.yml',
                   description: 'Simple alias with yaml body through Accept header' }

# Check version skip logic
skipped_tests << { file:        'create/15_without_id.yml',
                   description: 'Create without ID' }

# No error is raised
skipped_tests << { file:        'create/15_without_id_with_types.yml',
                   description: 'Create without ID' }

# Error message doesn't match
skipped_tests << { file:        'tasks.get/10_basic.yml',
                   description: 'get task test' }

# No error is raised
skipped_tests << { file:        'cat.allocation/10_basic.yml',
                   description: '*' }

# Figure out how to match response when there is an error
skipped_tests << { file:        'delete/70_mix_typeless_typeful.yml',
                   description: '*' }

# Figure out how to match response when there is an error
skipped_tests << { file:        'cat.templates/10_basic.yml',
                   description: '*' }

# node_selector is not supported yet
skipped_tests << { file: 'cat.aliases/10_basic.yml',
                   description: '*' }

# Responses are there but not equal (eg.: yellow status)
skipped_tests << { file: 'cluster.health/10_basic.yml',
                   description: 'cluster health with closed index (pre 7.2.0)' }

# Regular expression not catching exact match:
skipped_tests << { file: 'cat.indices/10_basic.yml',
                   description: 'Test cat indices output for closed index (pre 7.2.0)' }

# support for reloading password protected keystores was introduced in 8.0.0
skipped_tests << { file: 'nodes.reload_secure_settings/10_basic.yml',
                   description: 'node_reload_secure_settings test wrong password' }

SKIPPED_TESTS = skipped_tests

# The directory of rest api YAML files.
REST_API_YAML_FILES = SINGLE_TEST || Dir.glob("#{YAML_FILES_DIRECTORY}/**/*.yml")

# The features to skip
REST_API_YAML_SKIP_FEATURES = ['warnings'].freeze
