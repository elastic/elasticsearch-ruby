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
          chain = method_chain.split('.')

          # If we have a method nested in a namespace, client becomes the
          # client/namespace. Eg for `indices.resolve_index`, `client =
          # client.indices` and then we call `resolve_index` on `client`.
          if chain.size > 1
            client = chain[0...-1].inject(client) do |_client, _method|
              _client.send(_method)
            end
          end

          _method = chain[-1]
          case _method
          when 'headers'
            headers = prepare_arguments(args, test)
            # TODO: Remove Authorization headers while x_pack_rest_user is fixed
            if headers[:Authorization] == 'Basic eF9wYWNrX3Jlc3RfdXNlcjp4LXBhY2stdGVzdC1wYXNzd29yZA=='
              headers.delete(:Authorization)
            end
            if ENV['QUIET'] == 'true'
              # todo: create a method on Elasticsearch::Client that can clone the client with new options
              Elasticsearch::Client.new(host: URL,
                                        transport_options: TRANSPORT_OPTIONS.merge( headers: headers))
            else
              Elasticsearch::Client.new(host: URL,
                                        tracer: Logger.new($stdout),
                                        transport_options: TRANSPORT_OPTIONS.merge( headers: headers))
            end
          when 'catch', 'warnings', 'allowed_warnings'
            client
          else
            @response = client.send(_method, prepare_arguments(args, test))
            client
          end
        end
      end

      def yaml_response?
        @definition['headers'] && @definition['headers']['Accept'] == 'application/yaml'
      end

      private

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
                      # The arguments may contain the variable in the form ${variable} or $variable
                      value.gsub!(/\$\{?#{cached}\}?/, test.cached_values[cached].to_s)
                    end
                    args[key] = value
                  end
                when Time
                  # The YAML parser reads in dates as Time objects, reconvert to a format Elasticsearch accepts
                  args[key] = (value.to_f * 1000).to_i
                end
              end
            elsif args.is_a?(String)
              if cached_value = test.cached_values.find { |k, v| args =~ /\$\{?#{k}\}?/ }
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
