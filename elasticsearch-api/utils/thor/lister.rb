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

# encoding: UTF-8

require 'thor'

require 'pathname'

module Elasticsearch
  module API
    class Lister < Thor
      namespace 'api'

      DEFAULT_PATH = '../../tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/api/'.freeze

      desc "list <PATH DIRECTORY WITH JSON SPEC FILES>", "List all the REST API endpoints from the JSON specification"
      method_option :verbose,  type: :boolean, default: false, desc: 'Output more information'
      method_option :format,   default: 'text', desc: 'Output format (text, json)'
      def list(directory = DEFAULT_PATH)
        input = Pathname(directory).join('*.json')
        apis = Dir[input.to_s].map do |f|
          File.basename(f, '.json')
        end.sort

        if options[:verbose]
          say_status 'Count', apis.size
          say '▬'*terminal_width
        end

        case options[:format]
          when 'text'
            apis.each { |a| puts "* #{a}" }
          when 'json'
            puts apis.inspect
          else
            puts "[!] ERROR: Unknown output format '#{options[:format]}'"
            exit(1)
        end
      end
    end
  end
end
