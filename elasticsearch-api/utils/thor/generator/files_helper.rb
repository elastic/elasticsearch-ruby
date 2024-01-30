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

require 'pathname'
require_relative '../../../lib/elasticsearch/api/version.rb'

module Elasticsearch
  module API
    # Helper with file related methods for code generation
    module FilesHelper

      PROJECT_PATH = File.join(File.dirname(__FILE__), '..')
      SRC_PATH   = File.join(PROJECT_PATH, '..', '..', '..', 'tmp/rest-api-spec/api/')
      OUTPUT_DIR = '../../elasticsearch-api/lib/elasticsearch/api/actions'.freeze
      TESTS_DIRECTORY = "#{PROJECT_PATH}/../../../tmp/rest-api-spec/test/free".freeze

      class << self
        # Only get JSON files and remove hidden files
        def files
          json_files = Dir.entries(SRC_PATH)

          json_files.reject do |file|
            File.extname(file) != '.json' ||
              File.basename(file) == '_common.json'
          end.map { |file| "#{SRC_PATH}#{file}" }
        end

        # Path to directory to copy generated files
        def output_dir
          Pathname(OUTPUT_DIR)
        end

        def documentation_url(documentation_url)
          branch = `git rev-parse --abbrev-ref HEAD`
          return documentation_url.gsub(/\/(master|main)\//, "/current/") if branch == "main\n"

          regex = /([0-9]{1,2}\.[0-9x]{1,2})/
          version = Elasticsearch::API::VERSION.match(regex)[0]
          # TODO - How do we fix this so it doesn't depend on which branch we're running from
          if ENV['IGNORE_VERSION']
            documentation_url.gsub(/\/(master|main)\//, "/current/")
          else
            documentation_url.gsub(/\/(current|master|main)\//, "/#{version}/")
          end
        end
      end

      def cleanup_output_dir!
        FileUtils.remove_dir(OUTPUT_DIR)
        Dir.mkdir(OUTPUT_DIR)
      end
    end
  end
end
