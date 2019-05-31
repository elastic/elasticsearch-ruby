# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#	http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

require "#{File.expand_path(File.dirname('..'), '..')}/api-spec-testing/test_file"

TRANSPORT_OPTIONS = {}
PROJECT_PATH = File.join(File.dirname(__FILE__), '..', '..')

if hosts = ELASTICSEARCH_URL
  split_hosts = hosts.split(',').map do |host|
    /(http\:\/\/)?(\S+)/.match(host)[2]
  end

  TEST_HOST, TEST_PORT = split_hosts.first.split(':')
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

SKIPPED_TESTS = skipped_tests

# The directory of rest api YAML files.
REST_API_YAML_FILES = SINGLE_TEST || Dir.glob("#{YAML_FILES_DIRECTORY}/**/*.yml")

# The features to skip
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
  # a number can be a string key in a Hash or indicate an element in a list
  if document.is_a?(Hash)
    find_value_in_document(chain[1..-1], document[chain[0].to_s]) if document[chain[0].to_s]
  elsif document[chain[0]]
    find_value_in_document(chain[1..-1], document[chain[0]]) if document[chain[0]]
  end
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

# Replace the `$master` substring in a key with the cached master node's id.
#
# @param [ String ] expected_key The expected key, containing the substring `$master` that needs to be replaced.
# @param [ Elasticsearch::RestAPIYAMLTests::TestFile::Test ] test The test.
#
# See test xpack/10_basic.yml
#
# @return [ String ] The altered key.
#
# @since 7.1.1
def inject_master_node_id(expected_key, test)
  if test.cached_values['master']
    expected_key.gsub(/\$master/, test.cached_values['master'])
  else
    expected_key
  end
end
