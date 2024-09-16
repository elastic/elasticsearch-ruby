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
require 'multi_json'
require 'coderay'
require 'pry'
require_relative 'generator/build_hash_helper'
require_relative 'generator/docs_helper'
require_relative 'generator/files_helper'
require_relative './endpoint_spec'

module Elasticsearch
  module API
    # A command line application based on [Thor](https://github.com/wycats/thor),
    # which will read the JSON API spec file(s), and generate
    # the Ruby source code (one file per API endpoint) with correct
    # module namespace, method names, and RDoc documentation,
    # as well as test files for each endpoint.
    #
    # Specific exceptions and code snippets that need to be included are written
    # in EndpointSpecifics (generator/endpoint_specifics) and the module is included
    # here.
    #
    class SourceGenerator < Thor
      namespace 'code'
      include Thor::Actions
      include EndpointSpecifics
      include DocsHelper

      desc 'generate', 'Generate source code and tests from the REST API JSON specification'
      method_option :verbose, type: :boolean, default: false,  desc: 'Output more information'
      method_option :tests,   type: :boolean, default: false,  desc: 'Generate test files'

      def generate
        @build_hash = BuildHashHelper.build_hash
        self.class.source_root File.expand_path(__dir__)
        generate_source

        # -- Tree output
        print_tree if options[:verbose]
      end

      private

      def generate_source
        output = FilesHelper.output_dir
        cleanup_directory!(output)

        FilesHelper.files.each do |filepath|
          @spec = EndpointSpec.new(filepath)
          say_status 'json', @spec.path, :yellow
          # Don't generate code for internal APIs:
          next if @spec.skippable?

          path_to_file = output.join(@spec.module_namespace.join('/')).join("#{@spec.method_name}.rb")
          dir = output.join(@spec.module_namespace.join('/'))
          empty_directory(dir, verbose: false)

          # Write the file with the ERB template:
          template('templates/method.erb', path_to_file, force: true)

          # Optionals:
          print_source_code(path_to_file) if options[:verbose]
          generate_tests if options[:tests]
        end
        run_rubocop
        BuildHashHelper.add_hash(@build_hash)
      end

      def generate_tests
        copy_file 'templates/test_helper.rb', @output.join('test').join('test_helper.rb')

        @test_directory = @output.join('test/api').join(@module_namespace.join('/'))
        @test_file      = @test_directory.join("#{@method_name}_test.rb")

        empty_directory @test_directory
        template 'templates/test.erb', @test_file

        print_source_code(@test_file) if options[:verbose]
      end

      def print_source_code(path_to_file)
        colorized_output = CodeRay.scan_file(path_to_file, :ruby).terminal
        lines            = colorized_output.split("\n")
        formatted        = lines.first + "\n" + lines[1, lines.size].map { |l| ' ' * 14 + l }.join("\n")

        say_status('ruby', formatted, :yellow)
      end

      def print_tree
        return unless `which tree > /dev/null 2>&1; echo $?`.to_i < 1

        lines = `tree #{@output}`.split("\n")
        say_status('tree', lines.first + "\n" + lines[1, lines.size].map { |l| ' ' * 14 + l }.join("\n"))
      end

      def cleanup_directory!(output)
        Dir["#{output}/**/*.rb"].each do |file|
          # file = File.join(@output, f)
          File.delete(file) unless (['.', '..'].include? file) || Pathname(file).directory?
        end
      end

      def run_rubocop
        system("rubocop -c ./thor/.rubocop.yml --format autogenconf -a #{FilesHelper::output_dir}")
      end
    end
  end
end
