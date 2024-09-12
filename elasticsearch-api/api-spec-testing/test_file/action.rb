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
  module RestAPIYAMLTests
    # Class representing a single action. An action is one of the following:
    #
    #   1. Applying header settings on a client.
    #   2. Sending some request to Elasticsearch.
    #   3. Sending some request to Elasticsearch, expecting an exception.
    #
    # @since 6.2.0
    class Action
      attr_reader :response

      # Initialize an Action object.
      #
      # @example Create an action object:
      #   Action.new("xpack.watcher.get_watch" => { "id" => "my_watch" })
      #
      # @param [ Hash ] definition The action definition.
      #
      # @since 6.2.0
      def initialize(definition)
        @definition = definition
        @retries = 0
      end

      # Execute the action. The method returns the client, in case the action created a new client
      #   with header settings.
      #
      # @example Execute the action.
      #   action.execute(client, test)
      #
      # @param [ Elasticsearch::Client ] client The client to use to execute the action.
      # @param [ Test ] test The test containing this action. Necessary for caching variables.
      #
      # @return [ Elasticsearch::Client ] The client. It will be a new one, not the one passed in,
      #   if the action is to set headers.
      #
      # @since 6.2.0
      def execute(client, test = nil)
        @definition.each.inject(client) do |client, (method_chain, args)|
          if method_chain.match?('_internal')
            perform_internal(method_chain, args, client, test)
          else
            chain = method_chain.split('.')
            # If we have a method nested in a namespace, client becomes the
            # client/namespace. Eg for `indices.resolve_index`, `client =
            # client.indices` and then we call `resolve_index` on `client`.
            if chain.size > 1
              client = chain[0...-1].inject(client) do |shadow_client, method|
                shadow_client.send(method)
              end
            end
            _method = chain[-1]

            perform_action(_method, args, client, test)
          end
        end
      end

      def yaml_response?
        @definition['headers'] && @definition['headers']['Accept'] == 'application/yaml'
      end

      private

      # Executes operations not implemented by elasticsearch-api, such as _internal
      def perform_internal(method, args, client, test)
        es_version = test.cached_values['es_version'] unless test.nil?
        case method
        when '_internal.update_desired_nodes'
          http = 'PUT'
          if (history_id = args.delete('history_id')).match?(/\s+/)
            require 'erb'
            history_id = ERB::Util.url_encode(history_id)
          end
          path = "/_internal/desired_nodes/#{history_id}/#{args.delete('version')}"
          body = args.delete('body')
          # Replace $es_version with actual value:
          body['nodes'].map do |node|
            node['node_version']&.gsub!('$es_version', es_version) if node['node_version'] && es_version
          end if body['nodes']
        when '_internal.delete_desired_nodes'
          http = 'DELETE'
          path = '/_internal/desired_nodes/'
          body = args.delete('body')
        when /_internal\.get_([a-z_]+)/
          http = 'GET'
          path = case Regexp.last_match(1)
                 when 'desired_nodes'
                   '/_internal/desired_nodes/_latest'
                 when 'desired_balance'
                   '/_internal/desired_balance'
                 end
          body = nil
        when '_internal.health'
          path = if args['feature']
                   "_internal/_health/#{args.delete('feature')}/"
                 else
                   '_internal/_health'
                 end
          http = 'GET'
          body = args.delete('body')
        when '_internal.prevalidate_node_removal'
          path = '/_internal/prevalidate_node_removal'
          http = 'POST'
          body = args.delete('body')
        end
        args = prepare_arguments(args, test)
        @response = Elasticsearch::API::Response.new(client.perform_request(http, path, args, body))
        client
      end

      def perform_action(method, args, client, test)
        case method
        when 'bulk'
          arguments = prepare_arguments(args, test)
          arguments[:body].map! do |item|
            if item.is_a?(Hash)
              item
            elsif item.is_a?(String)
              symbolize_keys(JSON.parse(item))
            end
          end if arguments[:body].is_a? Array
          @response = client.send(method, arguments)
          client
        when 'headers'
          headers = prepare_arguments(args, test)
          host = client.transport.instance_variable_get('@hosts')
          transport_options = client.transport.instance_variable_get('@options')&.dig(:transport_options) || {}
          if ENV['QUIET'] == 'true'
            # todo: create a method on Elasticsearch::Client that can clone the client with new options
            Elasticsearch::Client.new(
              host: host,
              transport_options: transport_options.merge(headers: headers)
            )
          else
            Elasticsearch::Client.new(
              host: host,
              tracer: Logger.new($stdout),
              transport_options: transport_options.merge(headers: headers)
            )
          end
        when 'catch', 'warnings', 'allowed_warnings', 'allowed_warnings_regex', 'warnings_regex'
          client
        when 'put_trained_model_alias'
          args.merge!('reassign' => true) unless args['reassign'] === false
          @response = client.send(method, prepare_arguments(args, test))
          client
        when 'create'
          begin
            @response = client.send(method, prepare_arguments(args, test))
          rescue Elastic::Transport::Transport::Errors::BadRequest => e
            case e.message
            when /resource_already_exists_exception/
              client.delete(index: args['index'])
            when /failed to parse date field/
              body = args['body']
              time_series = body['settings']['index']['time_series']
              time_series.each { |k, v| time_series[k] = v.strftime("%FT%TZ") }
              args['body'] = body
            else
              raise e
            end
            @response = client.send(method, prepare_arguments(args, test))
          end
          client
        when 'update_user_profile_data', 'get_user_profile', 'enable_user_profile', 'disable_user_profile'
          args.each do |key, value|
            args[key] = value.gsub(value, test.cached_values[value.gsub('$', '')]) if value.match?(/^\$/)
          end
          @response = client.send(method, prepare_arguments(args, test))
          client
        else
          @response = client.send(method, prepare_arguments(args, test))
          client
        end
      rescue Elastic::Transport::Transport::Error => e
        if e.message.match(/Net::ReadTimeout/) && @retries <= 5
          @retries += 1
          perform_action(method, args, client, test)
        else
          raise e
        end
      end

      def prepare_arguments(args, test)
        symbolize_keys(args).tap do |args|
          if test
            if args.is_a?(Hash)
              args.each do |key, value|
                case value
                when Hash
                  args[key] = prepare_arguments(value, test)
                when Array
                  args[key] = value.collect { |v| prepare_arguments(v, test) }
                when String
                  # Find the cached values where the variable name is contained in the arguments.
                  if(cached_values = test.cached_values.keys.select { |k| value =~ /\$\{?#{k}\}?/ })
                    cached_values.each do |cached|
                      # Arguments can be $variable, ${variable} or a Hash:
                      retrieved = test.cached_values[cached]
                      if retrieved.is_a?(Hash)
                        value = retrieved
                      else
                        # Regex substitution to replace ${variable} or $variable for the value
                        value.gsub!(/\$\{?#{cached}\}?/, retrieved.to_s)
                      end
                    end
                    args[key] = value
                  end
                when Time
                  # The YAML parser reads in dates as Time objects, reconvert to a format Elasticsearch accepts
                  args[key] = (value.to_f * 1000).to_i
                end
              end
            elsif args.is_a?(String)
              if (cached_value = test.cached_values.find { |k, _v| args =~ /\$\{?#{k}\}?/ })
                return cached_value[1]
              end
            end
          end
        end
      end

      def symbolize_keys(object)
        if object.is_a? Hash
          object.reduce({}) { |memo,(k,v)| memo[k.to_s.to_sym] = symbolize_keys(v); memo }
        else
          object
        end
      end
    end
  end
end
