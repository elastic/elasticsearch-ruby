module Elasticsearch
  module API
    module Cat
      module Actions

        VALID_HELP_PARAMS = [ :help ].freeze

        # Help information for the Cat API
        #
        # @option arguments [Boolean] :help Return help information
        #
        # @see http://www.elasticsearch.org/guide/en/elasticsearch/reference/master/cat.html
        #
        def help(arguments={})
          help_request_for(arguments).body
        end

        def help_request_for(arguments={})
          method = HTTP_GET
          path   = "_cat"
          params = Utils.__validate_and_extract_params arguments, VALID_HELP_PARAMS
          body   = nil

          perform_request(method, path, params, body)
        end
      end
    end
  end
end
