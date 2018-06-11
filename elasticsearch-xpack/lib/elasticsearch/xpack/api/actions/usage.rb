module Elasticsearch
  module XPack
    module API
      module Actions

        # Retrieve information about X-Pack features usage
        #
        # @option arguments [Duration] :master_timeout Specify timeout for watch write operation
        #
        #
        def usage(arguments={})
          valid_params = [ :master_timeout ]
          method = Elasticsearch::API::HTTP_GET
          path   = "_xpack/usage"
          params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
          body   = nil

          perform_request(method, path, params, body).body
        end
      end
    end
  end
end
