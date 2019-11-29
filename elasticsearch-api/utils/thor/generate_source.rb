# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

# encoding: UTF-8

require 'thor'

require 'pathname'
require 'active_support/core_ext/hash/deep_merge'
require 'active_support/inflector'
require 'multi_json'
require 'coderay'
require 'pry'

module Elasticsearch

  module API

    # A command line application based on [Thor](https://github.com/wycats/thor),
    # which will read the JSON API spec file(s), and generate
    # the Ruby source code (one file per API endpoint) with correct
    # module namespace, method names, and RDoc documentation,
    # as well as test files for each endpoint.
    #
    class SourceGenerator < Thor
      namespace 'api:code'

      include Thor::Actions

      SRC_PATH = '../../../../tmp/elasticsearch/rest-api-spec/src/main/resources/rest-api-spec/api/'.freeze
      __root = Pathname( File.expand_path('../../..', __FILE__) )

      desc "generate", "Generate source code and tests from the REST API JSON specification"
      method_option :force,    type: :boolean,                               default: false, desc: 'Overwrite the output'
      method_option :verbose,  type: :boolean,                               default: false, desc: 'Output more information'
      method_option :input,    default: File.expand_path(SRC_PATH,           __FILE__),      desc: 'Path to directory with JSON API specs'
      method_option :output,   default: File.expand_path('../../../tmp/out', __FILE__),      desc: 'Path to output directory'

      def generate(*files)
        self.class.source_root File.expand_path('../', __FILE__)

        @input  = Pathname(options[:input])
        @output = Pathname(options[:output])

        # -- Test helper
        copy_file "templates/test_helper.rb", @output.join('test').join('test_helper.rb')

        # Remove unwanted files
        files = Dir.entries(@input.to_s).reject do |f|
          f.start_with?('.') ||
            f.start_with?('_') ||
            File.extname(f) != '.json'
        end

        files.each do |filepath|
          file    = @input.join(filepath)

          @path   = Pathname(file)
          @json   = MultiJson.load( File.read(@path) )

          @spec   = @json.values.first
          say_status 'json', @path, :yellow

          @spec['url'] ||= {}

          # say_status 'JSON', @spec.inspect, options[:verbose]

          @full_namespace   = @json.keys.first.split('.')
          @namespace_depth  = @full_namespace.size > 0 ? @full_namespace.size-1 : 0
          @module_namespace = @full_namespace[0, @namespace_depth]
          @method_name      = @full_namespace.last

          @parts            = __endpoint_parts
          @params           = @spec['params'] || {}

          method            = @spec['url']['paths'].map { |a| a['methods'] }.flatten.first
          @http_method      = "HTTP_#{method}"
          @http_path_params = __path_params
          @http_path        = unless false
                                @spec['url']['paths'].first['path']
                                  .split('/')
                                  .compact
                                  .reject { |p| p =~ /^\s*$/ }
                                  .map { |p| p =~ /\{/ ? "\#\{arguments[:#{p.tr('{}', '')}]\}" : p }
                                  .join('/')
                                  .gsub(/^\//, '')
                              else
                                @spec['url']['paths'].first.gsub(/^\//, '')
                              end
          # -- Ruby files

          @path_to_file = @output.join('api').join( @module_namespace.join('/') ).join("#{@method_name}.rb")

          empty_directory @output.join('api').join( @module_namespace.join('/') )

          template "templates/method.erb", @path_to_file

          if options[:verbose]
            colorized_output   = CodeRay.scan_file(@path_to_file, :ruby).terminal
            lines              =  colorized_output.split("\n")
            say_status 'ruby',
                       lines.first  + "\n" + lines[1, lines.size].map { |l| ' '*14 + l }.join("\n"),
                       :yellow
          end

          # --- Test files

          @test_directory = @output.join('test/api').join( @module_namespace.join('/') )
          @test_file      = @test_directory.join("#{@method_name}_test.rb")

          empty_directory @test_directory
          template "templates/test.erb", @test_file

          if options[:verbose]
            colorized_output   = colorized_output   = CodeRay.scan_file(@test_file, :ruby).terminal
            lines              =  colorized_output.split("\n")
            say_status 'ruby',
                       lines.first  + "\n" + lines[1, lines.size].map { |l| ' '*14 + l }.join("\n"),
                       :yellow
            say '▬'*terminal_width
          end
        end

        # -- Tree output

        if options[:verbose] && `which tree > /dev/null 2>&1; echo $?`.to_i < 1
          lines = `tree #{@output}`.split("\n")
          say_status 'tree',
                     lines.first  + "\n" + lines[1, lines.size].map { |l| ' '*14 + l }.join("\n")
        end
      end

      private

      # Create the hierarchy of directories based on API namespaces
      #
      def __create_directories(key, value)
        unless value['documentation']
          empty_directory @output.join(key)
          create_directory_hierarchy *value.to_a.first
        end
      end

      def __endpoint_parts
        parts = @spec['url']['paths'].select do |a|
          a.keys.include?('parts')
        end.map do |part|
          part&.[]('parts')
        end
        (parts.first || [])
      end

      def __path_params
        return nil if @parts.empty? || @parts.nil?
        params = []
        @parts.each do |name, _|
          params << "Utils.__listify(_#{name})"
        end
        ', ' + params.join(', ')
      end

    end
  end
end
