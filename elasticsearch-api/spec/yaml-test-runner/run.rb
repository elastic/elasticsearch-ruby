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

require 'logger'
require 'openssl'
require 'elasticsearch'
require 'elasticsearch/tests/test_runner'
require 'elasticsearch/tests/downloader'

PROJECT_PATH = File.join(File.dirname(__FILE__), '../..')
CERTS_PATH = "#{PROJECT_PATH}/../.buildkite/certs/".freeze
host = ENV['TEST_ES_SERVER'] || 'https://localhost:9200'
raise URI::InvalidURIError unless host =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

password = ENV['ELASTIC_PASSWORD'] || 'changeme'
uri = URI.parse(host)

if uri.is_a?(URI::HTTPS)
  raw_certificate = File.read("#{CERTS_PATH}/testnode.crt")
  certificate = OpenSSL::X509::Certificate.new(raw_certificate)
  raw_key = File.read("#{CERTS_PATH}/testnode.key")
  key = OpenSSL::PKey::RSA.new(raw_key)
  ca_file = File.expand_path("#{CERTS_PATH}/ca.crt")
  host = "https://elastic:#{password}@#{uri.host}:#{uri.port}".freeze
  transport_options = {
    ssl: {
      client_cert: certificate,
      client_key: key,
      ca_file: ca_file,
      verify: false
    }
  }
elsif uri.is_a?(URI::HTTP)
  host = "http://elastic:#{password}@#{uri.host}:#{uri.port}".freeze
  transport_options = {}
end

CLIENT = if ENV['ES_API_KEY']
           Elasticsearch::Client.new(host: host, api_key: ENV['ES_API_KEY'], transport_options: transport_options)
         else
           Elasticsearch::Client.new(host: host, transport_options: transport_options)
         end

tests_path = File.expand_path('./tmp', __dir__)

logger = Logger.new($stdout)
logger.level = Logger::WARN unless ENV['DEBUG']

# If we're running in a release branch, download the corresponding branch for tests
current_branch = `git rev-parse --abbrev-ref HEAD`.strip
branch = current_branch.match(/[0-9]\.[0-9]+/)&.[](0) || ENV['ES_YAML_TESTS_BRANCH'] || nil
Elasticsearch::Tests::Downloader::run(tests_path, branch)
Elasticsearch::Tests::TestRunner.new(CLIENT, tests_path, logger).run
