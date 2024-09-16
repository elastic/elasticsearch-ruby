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

require_relative 'endpoint_specifics'

module Elasticsearch
  module API
    class EndpointSpec
      include EndpointSpecifics

      # These APIs are private, but were added in 8.x since the generator didn't consider
      # visibility. They will be removed in 9.x since we're using a different generator that
      # considers visibility. But new private APIs code won't be generated for the client.
      EXCLUDED_8X = [
        'autoscaling.delete_autoscaling_policy', 'autoscaling.get_autoscaling_capacity',
        'autoscaling.get_autoscaling_policy', 'autoscaling.put_autoscaling_policy', 'capabilities',
        'connector.secret_delete', 'connector.secret_get', 'connector.secret_post',
        'connector.secret_put', 'fleet.delete_secret', 'fleet.get_secret', 'fleet.post_secret',
        'ml.validate', 'ml.validate_detector', 'monitoring.bulk', 'profiling.flamegraph',
        'profiling.stacktraces', 'profiling.status', 'profiling.topn_functions',
        'security.activate_user_profile', 'security.disable_user_profile',
        'security.enable_user_profile', 'security.get_user_profile',
        'security.has_privileges_user_profile', 'security.suggest_user_profiles',
        'security.update_user_profile_data', 'shutdown.delete_node', 'shutdown.get_node',
        'shutdown.put_node'
      ].freeze

      def initialize(filepath)
        @path = Pathname(filepath)
        json = MultiJson.load(File.read(@path))
        @spec = json.values.first
        @endpoint_name = json.keys.first

        full_namespace = parse_full_namespace
        @namespace_depth = full_namespace.size.positive? ? full_namespace.size - 1 : 0
        @module_namespace = full_namespace[0, @namespace_depth]
        @method_name = full_namespace.last

        @path_parts = parse_endpoint_parts(@spec)
        @params = @spec['params'] || {}
        @paths = @spec['url']['paths'].map { |b| b['path'] } if @spec['url']
        @path_params = path_variables.flatten.uniq.collect(&:to_sym)
        @http_method = parse_http_method(@spec)
        @deprecation_note = @spec['url']['paths'].last&.[]('deprecated')
        @http_path        = parse_http_path(@paths)
        @required_parts   = parse_required_parts(@spec)
      end

      attr_reader :module_namespace,
                  :method_name,
                  :endpoint_name,
                  :path,
                  :path_parts,
                  :params,
                  :deprecation_note,
                  :namespace_depth,
                  :http_path,
                  :required_parts,
                  :http_method,
                  :path_params,
                  :perform_request_opts

      def body
        @spec['body']
      end

      def documentation
        @spec['documentation']
      end

      def stability
        @spec['stability']
      end

      def visibility
        @spec['visibility']
      end

      def skippable?
        return true if module_namespace.flatten.first == '_internal'

        visibility != 'public' && !EXCLUDED_8X.include?(endpoint_name)
      end

      # Function that adds the listified h param code
      def specific_params
        super(@module_namespace.first, @method_name)
      end

      private

      def parse_full_namespace
        names = @endpoint_name.split('.')
        # Return an array to expand 'ccr', 'ilm', 'ml' and 'slm'
        names.map do |name|
          name
            .gsub(/^ml$/, 'machine_learning')
            .gsub(/^ilm$/, 'index_lifecycle_management')
            .gsub(/^ccr/, 'cross_cluster_replication')
            .gsub(/^slm/, 'snapshot_lifecycle_management')
        end
      end

      def parse_endpoint_parts(spec)
        parts = spec['url']['paths'].select do |a|
          a.keys.include?('parts')
        end.map do |path|
          path&.[]('parts')
        end
        (parts.inject(&:merge) || [])
      end

      def parse_http_method(spec)
        return '_id ? Elasticsearch::API::HTTP_PUT : Elasticsearch::API::HTTP_POST' if @endpoint_name == 'index'
        return '_name ? Elasticsearch::API::HTTP_PUT : Elasticsearch::API::HTTP_POST' if @method_name == 'create_service_token'
        return post_and_get if @endpoint_name == 'count'

        default_method = spec['url']['paths'].map { |a| a['methods'] }.flatten.first
        if spec['body'] && default_method == 'GET'
          # When default method is GET and body is required, we should always use POST
          if spec['body']['required']
            'Elasticsearch::API::HTTP_POST'
          else
            post_and_get
          end
        else
          "Elasticsearch::API::HTTP_#{default_method}"
        end
      end

      def parse_http_path(paths)
        return "\"#{parse_path(paths.first)}\"" if paths.size == 1

        result = ''
        anchor_string = []
        paths.sort { |a, b| b.length <=> a.length }.each_with_index do |path, i|
          var_string = extract_path_variables(path).map { |var| "_#{var}" }.join(' && ')
          next if anchor_string.include? var_string

          anchor_string << var_string
          result += if i.zero?
                      "if #{var_string}\n"
                    elsif (i == paths.size - 1) || var_string.empty?
                      "else\n"
                    else
                      "elsif #{var_string}\n"
                    end
          result += "\"#{parse_path(path)}\"\n"
        end
        result += 'end'
        result
      end

      def parse_path(path)
        path.gsub(/^\//, '')
            .gsub(/\/$/, '')
            .gsub('{', "\#{Utils.__listify(_")
            .gsub('}', ')}')
      end

      def path_variables
        @paths.map do |path|
          extract_path_variables(path)
        end
      end

      def parse_path_variables
        @paths.map do |path|
          extract_path_variables(path)
        end
      end

      # extract values that are in the {var} format:
      def extract_path_variables(path)
        path.scan(/{(\w+)}/).flatten
      end

      # Find parts that are definitely required and should raise an error if
      # they're not present
      #
      def parse_required_parts(spec)
        required = []
        return required if @endpoint_name == 'tasks.get'

        required << 'body' if (spec['body'] && spec['body']['required'])
        # Get required variables from paths:
        req_variables = parse_path_variables.inject(:&) # find intersection
        required << req_variables unless req_variables.empty?
        required.flatten
      end

      def post_and_get
        # the METHOD is defined after doing arguments.delete(:body), so we need to check for `body`
        <<~SRC
          if body
            Elasticsearch::API::HTTP_POST
          else
            Elasticsearch::API::HTTP_GET
          end
        SRC
      end
    end
  end
end
