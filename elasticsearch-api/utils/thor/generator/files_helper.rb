require 'pathname'

module Elasticsearch
  module API
    module FilesHelper
      SRC_PATH = '../../../../../tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/api/'.freeze
      OUTPUT_DIR = '../../elasticsearch-api/lib/elasticsearch/api/actions'.freeze

      # Path to directory with JSON API specs
      def self.input_dir
        input_dir = File.expand_path(SRC_PATH, __FILE__)
        Pathname(input_dir)
      end

      # Path to directory to copy generated files
      def self.output_dir
        Pathname(OUTPUT_DIR)
      end

      # Only get JSON files and remove hidden files
      def self.files
        Dir.entries(input_dir.to_s).reject do |f|
          f.start_with?('.') ||
            f.start_with?('_') ||
            File.extname(f) != '.json'
        end
      end
    end
  end
end
