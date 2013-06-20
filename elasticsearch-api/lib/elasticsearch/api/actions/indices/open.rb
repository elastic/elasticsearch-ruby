module Elasticsearch
  module API
    module Indices
      module Actions

        # Open a previously closed index (see the {Indices::Actions#close} API).
        #
        # @option arguments [String] :index The name of the index (*Required*)
        # @option arguments [Time] :timeout Explicit operation timeout
        #
        # @see http://www.elasticsearch.org/guide/reference/api/admin-indices-open-close/
        #
        def open(arguments={})
          raise ArgumentError, "Required argument 'index' missing" unless arguments[:index]
          method = 'POST'
          path   = "#{arguments[:index]}/_open"
          params = arguments.select do |k,v|
            [ :timeout ].include?(k)
          end
          # Normalize Ruby 1.8 and Ruby 1.9 Hash#select behaviour
          params = Hash[params] unless params.is_a?(Hash)
          body = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
