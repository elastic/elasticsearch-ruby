require 'pry-nav'
require 'yaml'
require 'elasticsearch'
require 'elasticsearch/xpack'
require 'logger'
require 'support/test_file'

RSpec.configure do |config|
  config.formatter = 'documentation'
  config.color = true
end

password = ENV['ELASTIC_PASSWORD']

ELASTICSEARCH_HOSTS = if hosts = ENV['TEST_ES_SERVER'] || ENV['ELASTICSEARCH_HOSTS']
                        hosts.split(',').map do |host|
                          /(http\:\/\/)?(\S+)/.match(host)[2]
                        end
                      end.freeze
TEST_HOST, TEST_PORT = ELASTICSEARCH_HOSTS.first.split(':') if ELASTICSEARCH_HOSTS

URL = ENV.fetch('TEST_CLUSTER_URL', "http://elastic:#{password}@#{TEST_HOST}:#{ENV['TEST_CLUSTER_PORT'] || 9200}")

ADMIN_CLIENT = Elasticsearch::Client.new(host: URL)
sleep(5)

if ENV['QUIET'] == 'true'
  DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL)
else
  DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL, tracer: Logger.new($stdout))
end

YAML_FILES_DIRECTORY = "#{File.expand_path(File.dirname('..'), '..')}" +
                          "/tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/test/roles"
skipped_files = []

# ArgumentError for empty body
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/watcher/put_watch/10_basic.yml")

# The number of shards when a snapshot is successfully created is more than 1. Maybe because of the security index?
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/snapshot/10_basic.yml")

# The test inserts an invalid license, which makes all subsequent tests fail.
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/xpack/15_basic.yml")

# Searching the monitoring index returns no results.
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/monitoring/bulk/10_basic.yml")
skipped_files += Dir.glob("#{YAML_FILES_DIRECTORY}/monitoring/bulk/20_privileges.yml")

REST_API_YAML_FILES = Dir.glob("#{YAML_FILES_DIRECTORY}/**/*.yml") - skipped_files
REST_API_YAML_SKIP_FEATURES = ['warnings'].freeze


# Given a list of keys, find the value in a recursively nested document.
#
# @param [ Array<String> ] chain The list of nested document keys.
# @param [ Hash ] document The document to find the value in.
#
# @return [ Object ] The value at the nested key.
#
# @since 6.1.1
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
# @since 6.1.1
def split_and_parse_key(key)
  key.split(/(?<!\\)\./).map do |key|
    (key =~ /\A[-+]?[0-9]+\z/) ? key.to_i: key.gsub('\\', '')
  end.reject { |k| k == '$body' }
end
