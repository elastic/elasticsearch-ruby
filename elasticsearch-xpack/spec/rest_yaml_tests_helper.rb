# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/test_file"
require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/rspec_matchers"
include Elasticsearch::RestAPIYAMLTests

PROJECT_PATH = File.join(File.dirname(__FILE__), '..', '..')

TRANSPORT_OPTIONS = {}
TEST_SUITE = ENV['TEST_SUITE'].freeze

if hosts = ENV['TEST_ES_SERVER'] || ENV['ELASTICSEARCH_HOSTS']
  split_hosts = hosts.split(',').map do |host|
    /(http\:\/\/)?\S+/.match(host)
  end
  uri = URI.parse(split_hosts.first[0])
  TEST_HOST = uri.host
  TEST_PORT = uri.port
else
  TEST_HOST, TEST_PORT = 'localhost', '9200'
end

raw_certificate = File.read(File.join(PROJECT_PATH, '/.ci/certs/testnode.crt'))
certificate = OpenSSL::X509::Certificate.new(raw_certificate)

raw_key = File.read(File.join(PROJECT_PATH, '/.ci/certs/testnode.key'))
key = OpenSSL::PKey::RSA.new(raw_key)

ca_file = File.join(PROJECT_PATH, '/.ci/certs/ca.crt')

if defined?(TEST_HOST) && defined?(TEST_PORT)
  if TEST_SUITE == 'security'
    TRANSPORT_OPTIONS.merge!(:ssl => { verify: false,
                                       client_cert: certificate,
                                       client_key: key,
                                       ca_file: ca_file })

    password = ENV['ELASTIC_PASSWORD']
    URL = "https://elastic:#{password}@#{TEST_HOST}:#{TEST_PORT}"
  else
    URL = "http://#{TEST_HOST}:#{TEST_PORT}"
  end

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
    "/tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test"

SINGLE_TEST = if ENV['SINGLE_TEST'] && !ENV['SINGLE_TEST'].empty?
                ["#{File.expand_path(File.dirname('..'), '..')}" +
                     "/tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test/#{ENV['SINGLE_TEST']}"]
              end

SKIPPED_TESTS = []

# Respone from Elasticsearch includes the ca.crt, so length doesn't match.
SKIPPED_TESTS << { file:        'ssl/10_basic.yml',
                   description: 'Test get SSL certificates' }

# Current license is basic.
SKIPPED_TESTS << { file:        'license/20_put_license.yml',
                   description: '*' }

# ArgumentError for empty body
SKIPPED_TESTS << { file:        'watcher/put_watch/10_basic.yml',
                   description: 'Test empty body is rejected by put watch' }

# The number of shards when a snapshot is successfully created is more than 1. Maybe because of the security index?
SKIPPED_TESTS << { file:        'snapshot/10_basic.yml',
                   description: 'Create a source only snapshot and then restore it' }

# The test inserts an invalid license, which makes all subsequent tests fail.
SKIPPED_TESTS << { file:        'xpack/15_basic.yml',
                   description: '*' }

# 'invalidated_tokens' is returning 5 in 'Test invalidate user's tokens' test.
SKIPPED_TESTS << { file:        'token/10_basic.yml',
                   description: "Test invalidate user's tokens" }

SKIPPED_TESTS << { file:        'token/10_basic.yml',
                   description: "Test invalidate realm's tokens" }

# Possible Docker issue. The IP from the response cannot be used to connect.HTTP input supports extracting of keys
SKIPPED_TESTS << { file:        'watcher/execute_watch/60_http_input.yml',
                   description: 'HTTP input supports extracting of keys' }

# Searching the monitoring index returns no results.
SKIPPED_TESTS << { file:        'monitoring/bulk/10_basic.yml',
                   description: 'Bulk indexing of monitoring data on closed indices should throw an export exception' }

# Searching the monitoring index returns no results.
SKIPPED_TESTS << { file:        'monitoring/bulk/20_privileges.yml',
                   description: 'Monitoring Bulk API' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Setting upgrade_mode to enabled' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Setting upgrade_mode to disabled' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Setting upgrade mode to disabled from enabled' }

# Operation times out "failed_node_exception"
SKIPPED_TESTS << { file:        'ml/set_upgrade_mode.yml',
                   description: 'Attempt to open job when upgrade_mode is enabled' }

# 'calendar3' in the field instead of 'calendar2'
SKIPPED_TESTS << { file:        'ml/calendar_crud.yml',
                   description: 'Test PageParams' }

# Error about creating a job that already exists.
SKIPPED_TESTS << { file:        'ml/jobs_crud.yml',
                   description: 'Test close job with body params' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/evaluate_data_frame.yml',
                   description: '*' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/start_data_frame_analytics.yml',
                   description: '*' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/stop_data_frame_analytics.yml',
                   description: '*' }

# Feature is currently experimental.
SKIPPED_TESTS << { file:        'ml/data_frame_analytics_crud.yml',
                   description: '*' }


# The directory of rest api YAML files.
REST_API_YAML_FILES = SINGLE_TEST || Dir.glob("#{YAML_FILES_DIRECTORY}/**/*.yml")

# The features to skip
REST_API_YAML_SKIP_FEATURES = ['warnings'].freeze
