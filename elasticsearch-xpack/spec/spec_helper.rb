require 'pry-nav'
require 'yaml'
require 'elasticsearch'
require 'elasticsearch/xpack'
require 'logger'
require 'support/test_file'


CURRENT_PATH = File.expand_path(File.dirname(__FILE__))

skipped_files = []
# ArgumentError for empty body
skipped_files += Dir.glob("#{CURRENT_PATH}/support/yaml_tests/watcher/put_watch/10_basic.yml")

# Elasticsearch is started with the xpack.watcher.index.rest.direct_access option set to true so indices can be cleared.
skipped_files += Dir.glob("#{CURRENT_PATH}/support/yaml_tests/watcher/block_direct_index_access/10_basic.yml")

# The number of shards when a snapshot is successfully created is more than 1. Maybe because of the security index?
skipped_files += Dir.glob("#{CURRENT_PATH}/support/yaml_tests/snapshot/10_basic.yml")

# The test inserts an invalid license, which makes all subsequent tests fail.
skipped_files += Dir.glob("#{CURRENT_PATH}/support/yaml_tests/xpack/15_basic.yml")

REST_API_YAML_FILES = Dir.glob("#{CURRENT_PATH}/support/yaml_tests/**/*.yml") - skipped_files
SKIP_FEATURES = ''

RSpec.configure do |config|
  config.formatter = 'documentation'
  config.color = true
end


password = ENV['ELASTIC_PASSWORD']
URL = ENV.fetch('TEST_CLUSTER_URL', "http://elastic:#{password}@localhost:#{ENV['TEST_CLUSTER_PORT'] || 9260}")
if ENV['QUIET'] == 'true'
  DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL)
else
  DEFAULT_CLIENT = Elasticsearch::Client.new(host: URL, tracer: Logger.new($stdout))
end


