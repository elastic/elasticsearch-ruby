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
    module FilesHelper
      OSS_SRC_PATH   = '../../../../../tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/api/'.freeze
      OSS_OUTPUT_DIR = '../../elasticsearch-api/lib/elasticsearch/api/actions'.freeze

      XPACK_SRC_PATH   = '../../../../../tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/api'.freeze
      XPACK_OUTPUT_DIR = '../../elasticsearch-xpack/lib/elasticsearch/xpack/api/actions'.freeze

      # Path to directory with JSON API specs
      def self.input_dir(api)
        input_dir = if api == :xpack
                      File.expand_path(XPACK_SRC_PATH, __FILE__)
                    else
                      File.expand_path(OSS_SRC_PATH, __FILE__)
                    end
        Pathname(input_dir)
      end

      # Path to directory to copy generated files
      def self.output_dir(api)
        api == :xpack ? Pathname(XPACK_OUTPUT_DIR) : Pathname(OSS_OUTPUT_DIR)
      end

      # Only get JSON files and remove hidden files
      def self.files(api)
        Dir.entries(input_dir(api).to_s).reject do |f|
          f.start_with?('.') ||
            f.start_with?('_') ||
            File.extname(f) != '.json'
        end
      end

      def self.gem_version
        regex = /([0-9]{1,2}\.[0-9x]{1,2})/
        Elasticsearch::API::VERSION.match(regex)[0]
      end
    end
  end
end
