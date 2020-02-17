require 'pathname'

module Elasticsearch
  module API
    module FilesHelper
      OSS_SRC_PATH   = '../../../../../tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/api/'.freeze
      OSS_OUTPUT_DIR = '../../elasticsearch-api/lib/elasticsearch/api/actions'.freeze

      XPACK_SRC_PATH   = '../../../../../tmp/elasticsearch/x-pack/plugin/src/test/resources/rest-api-spec/api'.freeze
      XPACK_OUTPUT_DIR = '../../elasticsearch-xpack/lib/elasticsearch/xpack/api/actions'.freeze

      # Path to directory with JSON API specs
      def self.input_dir(xpack = false)
        input_dir = if xpack
                      File.expand_path(XPACK_SRC_PATH, __FILE__)
                    else
                      File.expand_path(OSS_SRC_PATH, __FILE__)
                    end
        Pathname(input_dir)
      end

      # Path to directory to copy generated files
      def self.output_dir(xpack = false)
        xpack ? Pathname(XPACK_OUTPUT_DIR) : Pathname(OSS_OUTPUT_DIR)
      end

      # Only get JSON files and remove hidden files
      def self.files(xpack = false)
        Dir.entries(input_dir(xpack).to_s).reject do |f|
          f.start_with?('.') ||
            f.start_with?('_') ||
            File.extname(f) != '.json'
        end
      end
    end
  end
end
