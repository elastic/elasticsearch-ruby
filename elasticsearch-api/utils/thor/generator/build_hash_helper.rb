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

module Elasticsearch
  module API
    # Helper for the Elasticsearch build hash in source code docs
    module BuildHashHelper
      class << self
        def build_hash
          if ENV['BUILD_HASH']
            File.read(File.expand_path('../../../tmp/rest-api-spec/build_hash',__dir__))
          else
            original_build_hash
          end
        end

        def add_hash(build_hash)
          Dir.glob("#{FilesHelper.output_dir}/**/*.rb").each do |file|
            content = File.read(file)
            new_content = content.gsub(/(^#\sunder\sthe\sLicense.\n#)/) do |_|
              match = Regexp.last_match
              "#{match[1]}\n#{build_hash_comment(build_hash)}"
            end
            File.open(file, 'w') { |f| f.puts new_content }
          end
        end

        def build_hash_comment(build_hash)
          [
            "Auto generated from build hash #{build_hash}",
            '@see https://github.com/elastic/elasticsearch/tree/main/rest-api-spec',
            ''
          ].map { |b| "# #{b}" }.join("\n").strip
        end

        private

        def original_build_hash
          content = File.read("#{FilesHelper.output_dir}/info.rb")

          return unless (match = content.match(/Auto generated from build hash ([a-f0-9]+)/))

          match[1]
        rescue
          return 'Unavailable'
        end
      end
    end
  end
end
