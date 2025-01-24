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

require 'elasticsearch'
require 'openssl'
require 'rspec'

RSpec.configure do |config|
  config.formatter = :documentation
end

def meta_version
  client.send(:client_meta_version, Elasticsearch::VERSION)
end

def jruby?
  defined?(JRUBY_VERSION)
end

if ENV['TEST_WITH_OTEL'] == 'true'
  require 'opentelemetry-sdk'
  EXPORTER = OpenTelemetry::SDK::Trace::Export::InMemorySpanExporter.new
  span_processor = OpenTelemetry::SDK::Trace::Export::SimpleSpanProcessor.new(EXPORTER)

  OpenTelemetry::SDK.configure do |c|
    c.error_handler = ->(exception:, message:) { raise(exception || message) }
    c.logger = Logger.new($stderr, level: ENV.fetch('OTEL_LOG_LEVEL', 'fatal').to_sym)
    c.add_span_processor span_processor
  end
end

CERTS_PATH = File.expand_path('../../.buildkite/certs', __dir__)
host = ENV['TEST_ES_SERVER'] || 'http://localhost:9200'
raise URI::InvalidURIError unless host =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

password = ENV['ELASTIC_PASSWORD'] || 'changeme'
HOST_URI = URI.parse(host)
raw_certificate = File.read("#{CERTS_PATH}/testnode.crt")
certificate = OpenSSL::X509::Certificate.new(raw_certificate)
raw_key = File.read("#{CERTS_PATH}/testnode.key")
key = OpenSSL::PKey::RSA.new(raw_key)
ca_file = File.expand_path("#{CERTS_PATH}/ca.crt")
TRANSPORT_OPTIONS = { ssl: { verify: false, client_cert: certificate, client_key: key, ca_file: ca_file } }
HOST = "https://elastic:#{password}@#{HOST_URI.host}:#{HOST_URI.port}"
CLIENT = Elasticsearch::Client.new(host: HOST, transport_options: TRANSPORT_OPTIONS)
