require 'pry-nav'
require 'yaml'
require 'elasticsearch'
require 'elasticsearch/xpack'
require 'logger'
require 'support/test_file'
require 'openssl'

RSpec.configure do |config|
  config.formatter = 'documentation'
  config.color = true
end

PROJECT_PATH = File.join(File.dirname(__FILE__), '..', '..')

TRANSPORT_OPTIONS = {}
TEST_SUITE = ENV['TEST_SUITE'].freeze

if hosts = ENV['TEST_ES_SERVER'] || ENV['ELASTICSEARCH_HOSTS']
  split_hosts = hosts.split(',').map do |host|
    /(http\:\/\/)?(\S+)/.match(host)[2]
  end

  TEST_HOST, TEST_PORT = split_hosts.first.split(':')
else
  TEST_HOST, TEST_PORT = 'localhost', '9200'
end

raw_certificate = File.read(File.join(PROJECT_PATH, '/.ci/certs/testnode.crt'))
certificate = OpenSSL::X509::Certificate.new(raw_certificate)

raw_key = File.read(File.join(PROJECT_PATH, '/.ci/certs/testnode.key'))
key = OpenSSL::PKey::RSA.new(raw_key)


if defined?(TEST_HOST) && defined?(TEST_PORT)
  if TEST_SUITE == 'security'
    TRANSPORT_OPTIONS.merge!(:ssl => { verify: false,
                                       client_cert: certificate,
                                       client_key: key,
                                       ca_file: '.ci/certs/ca.crt'})

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
skipped_files = []

# Respone from Elasticsearch includes the ca.crt, so length doesn't match.
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/ssl/10_basic.yml")

# Current license is basic.
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/license/20_put_license.yml")

# ArgumentError for empty body
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/watcher/put_watch/10_basic.yml")

# The number of shards when a snapshot is successfully created is more than 1. Maybe because of the security index?
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/snapshot/10_basic.yml")

# The test inserts an invalid license, which makes all subsequent tests fail.
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/xpack/15_basic.yml")

# 'invalidated_tokens' is returning 5 in 'Test invalidate user's tokens' test.
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/token/10_basic.yml")

# Searching the monitoring index returns no results.
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/monitoring/bulk/10_basic.yml")
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/monitoring/bulk/20_privileges.yml")


SINGLE_TEST = nil
# Uncomment the following line and set it to a file when a single test should be run.
# SINGLE_TEST = ["#{File.expand_path(File.dirname('..'), '..')}" +
#  "/tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test/rollup/rollup_search.yml"]


REST_API_YAML_FILES = SINGLE_TEST || Dir.glob("#{YAML_FILES_DIRECTORY}/**/*.yml") - skipped_files
REST_API_YAML_SKIP_FEATURES = ['warnings'].freeze


# Given a list of keys, find the value in a recursively nested document.
#
# @param [ Array<String> ] chain The list of nested document keys.
# @param [ Hash ] document The document to find the value in.
#
# @return [ Object ] The value at the nested key.
#
# @since 6.2.0
def find_value_in_document(chain, document)
  return document[chain[0]] unless chain.size > 1
  find_value_in_document(chain[1..-1], document[chain[0]]) if document[chain[0]]
end

# Given a string representing a nested document key using dot notation,
#   split it, keeping escaped dots as part of a key name and replacing
#   numerics with a Ruby Integer.
#
# For example:
#   "joe.metadata.2.key2" => ['joe', 'metadata', 2, 'key2']
#   "jobs.0.node.attributes.ml\\.enabled" => ["jobs", 0, "node", "attributes", "ml\\.enabled"]
#
# @param [ String ] chain The list of nested document keys.
# @param [ Hash ] document The document to find the value in.
#
# @return [ Array<Object> ] A list of the nested keys.
#
# @since 6.2.0
def split_and_parse_key(key)
  key.split(/(?<!\\)\./).map do |key|
    (key =~ /\A[-+]?[0-9]+\z/) ? key.to_i: key.gsub('\\', '')
  end.reject { |k| k == '$body' }
end


module HelperModule
  def self.included(context)

    context.let(:client_double) do
      Class.new { include Elasticsearch::XPack::API }.new.tap do |client|
        expect(client).to receive(:perform_request).with(*expected_args).and_return(response_double)
      end
    end

    context.let(:client) do
      Class.new { include Elasticsearch::XPack::API }.new.tap do |client|
        expect(client).to receive(:perform_request).with(*expected_args).and_return(response_double)
      end
    end

    context.let(:response_double) do
      double('response', status: 200, body: {}, headers: {})
    end
  end
end

RSpec.configure do |config|
  config.include(HelperModule)
  config.formatter = 'documentation'
  config.color = true
end
