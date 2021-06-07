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

require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/test_file"
require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/rspec_matchers"
include Elasticsearch::RestAPIYAMLTests

PROJECT_PATH = File.join(File.dirname(__FILE__), '..', '..')

TRANSPORT_OPTIONS = {}
TEST_SUITE = ENV['TEST_SUITE'].freeze || 'platinum'

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

raw_certificate = File.read(File.join(PROJECT_PATH, '.ci/certs/testnode.crt'))
certificate = OpenSSL::X509::Certificate.new(raw_certificate)

raw_key = File.read(File.join(PROJECT_PATH, '/.ci/certs/testnode.key'))
key = OpenSSL::PKey::RSA.new(raw_key)

ca_file = File.join(PROJECT_PATH, '/.ci/certs/ca.crt')

if defined?(TEST_HOST) && defined?(TEST_PORT)
  if TEST_SUITE == 'platinum'
    TRANSPORT_OPTIONS.merge!(
      ssl: { verify: false, client_cert: certificate, client_key: key, ca_file: ca_file }
    )
    password = ENV['ELASTIC_PASSWORD'] || 'changeme'
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

YAML_FILES_DIRECTORY = "#{PROJECT_PATH}/tmp/rest-api-spec/test/platinum"

SINGLE_TEST = if ENV['SINGLE_TEST'] && !ENV['SINGLE_TEST'].empty?
                test_target = ENV['SINGLE_TEST']
                path = File.expand_path(File.dirname('..'))

                if test_target.match?(/\.yml$/)
                  ["#{path}/../tmp/rest-api-spec/test/platinum/#{test_target}"]
                else
                  Dir.glob(
                    ["#{PROJECT_PATH}/tmp/rest-api-spec/test/platinum/#{test_target}/**/*.yml"]
                  )
                end
              end

# Skipped tests
file = File.expand_path(__dir__ + '/skipped_tests.yml')
skipped_tests = YAML.load_file(file)

# The directory of rest api YAML files.
REST_API_YAML_FILES = if ENV['RUN_SKIPPED_TESTS'] # only run the skipped tests if true
                        SKIPPED_TESTS = []
                        skipped_tests.map { |test| "#{YAML_FILES_DIRECTORY}/#{test[:file]}" }
                      else
                        # If not, define the skipped tests constant and try the single test or all
                        # the tests
                        SKIPPED_TESTS = skipped_tests
                        SINGLE_TEST || Dir.glob("#{YAML_FILES_DIRECTORY}/**/*.yml")
                      end

# The features to skip
REST_API_YAML_SKIP_FEATURES = ['warnings', 'node_selector'].freeze
