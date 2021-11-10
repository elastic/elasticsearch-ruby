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
require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/wipe_cluster"
include Elasticsearch::RestAPIYAMLTests

TRANSPORT_OPTIONS = {}
PROJECT_PATH = File.join(File.dirname(__FILE__), '..')
STACK_VERSION = ENV['STACK_VERSION']
require 'elasticsearch/xpack'

if (hosts = ELASTICSEARCH_URL)
  split_hosts = hosts.split(',').map do |host|
    /(http\:\/\/)?\S+/.match(host)
  end
  uri = URI.parse(split_hosts.first[0])
  TEST_HOST = uri.host
  TEST_PORT = uri.port
else
  TEST_HOST, TEST_PORT = 'localhost', '9200'
end

test_suite = ENV['TEST_SUITE'] || 'free'
password = ENV['ELASTIC_PASSWORD'] || 'changeme'
user = ENV['ELASTIC_USER'] || 'elastic'

if defined?(TEST_HOST) && defined?(TEST_PORT)
  URL = "http://#{TEST_HOST}:#{TEST_PORT}".freeze

  if STACK_VERSION.match?(/^8\./)
    if ENV['TEST_SUITE'] == 'platinum'
      raw_certificate = File.read(File.join(PROJECT_PATH, '../.ci/certs/testnode.crt'))
      certificate = OpenSSL::X509::Certificate.new(raw_certificate)
      raw_key = File.read(File.join(PROJECT_PATH, '../.ci/certs/testnode.key'))
      key = OpenSSL::PKey::RSA.new(raw_key)
      ca_file = File.expand_path(File.join(PROJECT_PATH, '/.ci/certs/ca.crt'))
      host = "https://elastic:#{password}@#{uri.host}:#{uri.port}".freeze
      transport_options = { ssl: { verify: false, client_cert: certificate, client_key: key, ca_file: ca_file } }
    else
      host = "http://elastic:#{password}@#{uri.host}:#{uri.port}".freeze
      transport_options = {}
    end

    ADMIN_CLIENT = Elasticsearch::Client.new(host: host, transport_options: transport_options)

    DEFAULT_CLIENT = if ENV['QUIET'] == 'true'
                       Elasticsearch::Client.new(host: host, transport_options: transport_options)
                     else
                       Elasticsearch::Client.new(
                         host: host,
                         tracer: Logger.new($stdout),
                         transport_options: transport_options
                       )
                     end

    if ENV['QUIET'] == 'true'
      DEFAULT_CLIENT = Elasticsearch::Client.new(
        host: URL,
        transport_options: TRANSPORT_OPTIONS,
        user: user,
        password: password
      )
    else
      DEFAULT_CLIENT = Elasticsearch::Client.new(
        host: URL,
        transport_options: TRANSPORT_OPTIONS,
        user: user,
        password: password,
        tracer: Logger.new($stdout)
      )
    end
  else
    ADMIN_CLIENT = Elasticsearch::Client.new(host: URL, transport_options: TRANSPORT_OPTIONS)

    if ENV['QUIET'] == 'true'
      DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL, transport_options: TRANSPORT_OPTIONS)
    else
      DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL,
                                                 transport_options: TRANSPORT_OPTIONS,
                                                 tracer: Logger.new($stdout))
    end
  end
end

YAML_FILES_DIRECTORY = "#{PROJECT_PATH}/../tmp/rest-api-spec/#{STACK_VERSION.match?(/^8\./) ? 'compatTest' : 'test'}/free"

SINGLE_TEST = if ENV['SINGLE_TEST'] && !ENV['SINGLE_TEST'].empty?
                test_target = ENV['SINGLE_TEST']

                if test_target.match?(/\.yml$/)
                  ["#{PROJECT_PATH}/../tmp/rest-api-spec/test/free/#{test_target}"]
                else
                  Dir.glob(
                    ["#{PROJECT_PATH}/../tmp/rest-api-spec/test/free/#{test_target}/*.yml"]
                  )
                end
              end

# Skipped tests
file = File.expand_path("#{__dir__}/skipped_tests.yml")
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
