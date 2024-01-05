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

require 'openssl'
require 'elasticsearch'

CERTS_PATH = File.expand_path('./../.buildkite/certs')

host = ENV['TEST_ES_SERVER'] || 'https://localhost:9200'
raise URI::InvalidURIError unless host =~ /\A#{URI::DEFAULT_PARSER.make_regexp}\z/

password = ENV['ELASTIC_PASSWORD'] || 'changeme'
HOST_URI = URI.parse(host)
raw_certificate = File.read("#{CERTS_PATH}/testnode.crt")
certificate = OpenSSL::X509::Certificate.new(raw_certificate)
raw_key = File.read("#{CERTS_PATH}/testnode.key")
key = OpenSSL::PKey::RSA.new(raw_key)
ca_file = File.expand_path("#{CERTS_PATH}/ca.crt")
TRANSPORT_OPTIONS = { ssl: { verify: false, client_cert: certificate, client_key: key, ca_file: ca_file } }
HOST = "https://elastic:#{password}@#{HOST_URI.host}:#{HOST_URI.port}".freeze

ADMIN_CLIENT = Elasticsearch::Client.new(host: HOST, transport_options: TRANSPORT_OPTIONS)

RSpec.configure do |config|
  config.add_formatter('documentation')
  config.add_formatter('RSpec::Core::Formatters::HtmlFormatter', "tmp/platinum-#{ENV['RUBY_VERSION']}-manual-integration.html")
  config.color_mode = :on
end
