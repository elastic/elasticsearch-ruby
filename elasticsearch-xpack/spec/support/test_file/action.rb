module Elasticsearch

  module RestAPIYAMLTests

    # Class representing a single action. An action is one of the following:
    #
    #   1. Applying header settings on a client.
    #   2. Sending some request to Elasticsearch.
    #   3. Sending some request to Elasticsearch and expecting an exception.
    #
    # @since 6.1.1
    class Action

      attr_reader :response

      # Initialize an Action object.
      #
      # @example Create an action object:
      #   Action.new("xpack.watcher.get_watch" => { "id" => "my_watch" })
      #
      # @param [ Hash ] definition The action definition.
      #
      # @since 6.1.1
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
      # @return [ client ] The client.
      #
      # @since 6.1.1
      def execute(client, test = nil)
        @definition.each.inject(client) do |client, (method_chain, args)|
          chain = method_chain.split('.')

          if chain.size > 1
            client = chain[0...-1].inject(client) do |_client, _method|
              _client.send(_method)
            end
          end

          _method = chain[-1]
          case _method
          when 'headers'
            # todo: create a method on Elasticsearch::Client that can clone the client with new options
            Elasticsearch::Client.new(host: URL, transport_options: { headers: symbolize_keys(args) })
          when 'catch'
            client
          else
            @response = client.send(_method, prepare_arguments(args, test))
            client
          end
        end
      end

      private

      def prepare_arguments(args, test)
        args = symbolize_keys(args)
        if test
          args.collect do |key, value|
            if test.cached_values[value]
              args[key] = test.cached_values[value]
            end
          end
        end
        args
      end

      def symbolize_keys(object)
        if object.is_a? Hash
          object.reduce({}) { |memo,(k,v)| memo[k.to_sym] = symbolize_keys(v); memo }
        else
          object
        end
      end
    end
  end
end
