module Elasticsearch

  module RestAPIYAMLTests

    # Class representing a single action. An action is one of the following:
    #
    #   1. Applying header settings on a client.
    #   2. Sending some request to Elasticsearch.
    #   3. Sending some request to Elasticsearch, expecting an exception.
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
      # @return [ Elasticsearch::Client ] The client. It will be a new one than the one passed in,
      #   if the action is to set headers.
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
            if ENV['QUIET'] == 'true'
              # todo: create a method on Elasticsearch::Client that can clone the client with new options
              Elasticsearch::Client.new(host: URL,
                                        transport_options: TRANSPORT_OPTIONS.merge( headers: prepare_arguments(args, test)))
            else
              Elasticsearch::Client.new(host: URL, tracer: Logger.new($stdout),
                                        transport_options: TRANSPORT_OPTIONS.merge( headers: prepare_arguments(args, test)))
            end
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
        symbolize_keys(args).tap do |args|
          if test
            args.each do |key, value|
              case value
              when Hash
                args[key] = prepare_arguments(value, test)
              when String
                # Find the cached values where the variable name is contained in the arguments.
                if cached_value = test.cached_values.find { |k, v| value =~ /\$\{?#{k}\}?/ }
                  # The arguments may contain the variable in the form ${variable} or $variable
                  args[key] = value.gsub(/\$\{?#{cached_value[0]}\}?/, cached_value[1].to_s)
                end
              end
            end
          end
        end
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
